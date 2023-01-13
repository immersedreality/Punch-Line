//
//  CloudKitManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

final class CloudKitManager {

    private static let container = CKContainer.default()

    // MARK: iCloud

    class func accountIsAvailable() async -> Bool {

        do {
            let accountStatus = try await container.accountStatus()

            switch accountStatus {
            case .available:
                return true
            case .couldNotDetermine, .noAccount, .restricted, .temporarilyUnavailable:
                return false
            @unknown default:
                return false
            }
        } catch {
            return false
        }

    }

    class func requestUserDiscoverabilityPermission() async -> Bool {

        do {
            let accountPermissionStatus  = try await container.requestApplicationPermission(.userDiscoverability)

            switch accountPermissionStatus {
            case .granted:
                return true
            case .couldNotComplete, .denied, .initialState:
                return false
            @unknown default:
                return false
            }
        } catch {
            return false
        }

    }

    class func getAccountIfItExistsFor(emailAddress: String) async -> CKUserIdentity? {
        do {
            return try await container.userIdentity(forEmailAddress: emailAddress)
        } catch {
            return nil
        }
    }
    
    // MARK: Userbase

    class func generateNewUserbase(with username: String) async {
        let publicDatabase = container.publicCloudDatabase

        let userbaseRecord = CKRecord(recordType: UserbaseRecordKeys.type)
        userbaseRecord[UserbaseRecordKeys.allUsernames] = [username] as CKRecordValue

        do {
            try await publicDatabase.save(userbaseRecord)
        } catch {
            // TODO: Handle Error
        }
    }

    class func getUserbase() async -> Userbase? {
        let publicDatabase = container.publicCloudDatabase

        do {
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(recordType: UserbaseRecordKeys.type, predicate: NSPredicate(value: true)))
            let retrievedUserbaseResult = retrievedRecords.matchResults.first?.1

            switch retrievedUserbaseResult {
            case .success(let retrievedUserbaseRecord):
                let retrievedUserbase = Userbase(
                    allUsernames: retrievedUserbaseRecord[UserbaseRecordKeys.allUsernames] as? [String] ?? []
                )
                return retrievedUserbase
            case .failure, .none:
                return nil
            }
        } catch {
            return nil
        }
    }

    class func addUsernameToUserbase(username: String) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(recordType: UserbaseRecordKeys.type, predicate: NSPredicate(value: true)))
            let retrievedUserbaseResult = retrievedRecords.matchResults.first?.1

            switch retrievedUserbaseResult {
            case .success(let retrievedUserbaseRecord):
                var currentUserbase = retrievedUserbaseRecord[UserbaseRecordKeys.allUsernames] as? [String] ?? []
                guard !currentUserbase.contains(username) else { return }
                currentUserbase.append(username)
                retrievedUserbaseRecord.setValue(currentUserbase, forKey: UserbaseRecordKeys.allUsernames)
                try await publicDatabase.save(retrievedUserbaseRecord)
            case .failure, .none:
                break
            }

        } catch {
            // TODO: Handle Error
        }

    }

    // MARK: UserInfo

    class func saveNewUserInfo(with username: String) async -> UserInfo? {
        let privateDatabase = container.privateCloudDatabase

        let userInfoRecord = CKRecord(recordType: UserInfoRecordKeys.type)
        userInfoRecord[UserInfoRecordKeys.username] = username as CKRecordValue
        userInfoRecord[UserInfoRecordKeys.lastSignInDate] = Date() as CKRecordValue
        userInfoRecord[UserInfoRecordKeys.shouldSeeOffensiveContent] = true as CKRecordValue

        do {
            try await privateDatabase.save(userInfoRecord)
            await addUsernameToUserbase(username: username)
            return UserInfo(
                cloudKitID: userInfoRecord.recordID,
                username: userInfoRecord[UserInfoRecordKeys.username] as! String,
                lastSignInDate: userInfoRecord[UserInfoRecordKeys.lastSignInDate] as! Date,
                todaysPunchlines: userInfoRecord[UserInfoRecordKeys.todaysPunchlines] as? [String] ?? [],
                todaysTaskCounts: userInfoRecord[UserInfoRecordKeys.todaysTaskCounts] as? [Int] ?? [],
                shouldSeeOffensiveContent: userInfoRecord[UserInfoRecordKeys.shouldSeeOffensiveContent] as! Bool
            )
        } catch {
            return nil
        }

    }

    class func getUserInfo() async -> UserInfo? {
        let privateDatabase = container.privateCloudDatabase

        do {
            let retrievedRecords = try await privateDatabase.records(matching: CKQuery(recordType: UserInfoRecordKeys.type, predicate: NSPredicate(value: true)))
            let retrievedUserInfoResult = retrievedRecords.matchResults.first?.1

            switch retrievedUserInfoResult {
            case .success(let retrievedUserInfoRecord):
                let retrievedUserInfo = UserInfo(
                    cloudKitID: retrievedUserInfoRecord.recordID,
                    username: retrievedUserInfoRecord[UserInfoRecordKeys.username] as! String,
                    lastSignInDate: retrievedUserInfoRecord[UserInfoRecordKeys.lastSignInDate] as! Date,
                    todaysPunchlines: retrievedUserInfoRecord[UserInfoRecordKeys.todaysPunchlines] as? [String] ?? [],
                    todaysTaskCounts: retrievedUserInfoRecord[UserInfoRecordKeys.todaysTaskCounts] as? [Int] ?? [],
                    shouldSeeOffensiveContent: retrievedUserInfoRecord[UserInfoRecordKeys.shouldSeeOffensiveContent] as! Bool
                )
                return retrievedUserInfo
            case .failure, .none:
                return nil
            }
        } catch {
            return nil
        }

    }

    class func update(userInfo: UserInfo) async {
        let privateDatabase = container.privateCloudDatabase

        do {
            let retrievedRecords = try await privateDatabase.records(for: [userInfo.cloudKitID])
            let retrievedUserInfoResult = retrievedRecords.first?.1

            switch retrievedUserInfoResult {
            case .success(let retrievedUserInfoRecord):
                retrievedUserInfoRecord.setValue(userInfo.username, forKey: UserInfoRecordKeys.username)
                retrievedUserInfoRecord.setValue(userInfo.lastSignInDate, forKey: UserInfoRecordKeys.lastSignInDate)
                if !userInfo.todaysPunchlines.isEmpty {
                    retrievedUserInfoRecord.setValue(userInfo.todaysPunchlines, forKey: UserInfoRecordKeys.todaysPunchlines)
                }
                if !userInfo.todaysTaskCounts.isEmpty {
                    retrievedUserInfoRecord.setValue(userInfo.todaysTaskCounts, forKey: UserInfoRecordKeys.todaysTaskCounts)
                }
                retrievedUserInfoRecord.setValue(userInfo.shouldSeeOffensiveContent, forKey: UserInfoRecordKeys.shouldSeeOffensiveContent)
                try await privateDatabase.save(retrievedUserInfoRecord)
            case .failure, .none:
                break
            }
        } catch {
            // TODO: Handle Error
        }

    }

    class func deleteAllUserDataInCloud() async {
        let privateDatabase = container.privateCloudDatabase

        do {
            let retrievedRecords = try await privateDatabase.records(matching: CKQuery(recordType: UserInfoRecordKeys.type, predicate: NSPredicate(value: true)))
            let retrievedUserInfoID = retrievedRecords.matchResults.first?.0
            if let userInfoRecordID = retrievedUserInfoID {
                try await privateDatabase.deleteRecord(withID: userInfoRecordID)
            }
        } catch {
            // TODO: Handle Error
        }

    }

    // MARK: FavoriteJoke

    class func addFavorite(survivingJoke: SurvivingJoke, to userInfo: UserInfo) async {
        let privateDatabase = container.privateCloudDatabase

        do {
            let favoriteJokeRecord = CKRecord(recordType: FavoriteJokeRecordKeys.type)
            favoriteJokeRecord[FavoriteJokeRecordKeys.owningUser] = CKRecord.Reference(recordID: userInfo.cloudKitID, action: .deleteSelf)
            favoriteJokeRecord[FavoriteJokeRecordKeys.setup] = survivingJoke.setup as CKRecordValue
            favoriteJokeRecord[FavoriteJokeRecordKeys.setupAuthor] = survivingJoke.setupAuthor as CKRecordValue
            favoriteJokeRecord[FavoriteJokeRecordKeys.punchline] = survivingJoke.punchline as CKRecordValue
            favoriteJokeRecord[FavoriteJokeRecordKeys.punchlineAuthor] = survivingJoke.punchlineAuthor as CKRecordValue
            favoriteJokeRecord[FavoriteJokeRecordKeys.dateCreated] = survivingJoke.dateCreated as CKRecordValue
            try await privateDatabase.save(favoriteJokeRecord)
        } catch {
            return
        }

    }

    class func getFavoriteJokes(for userInfo: UserInfo) async -> [FavoriteJoke] {
        let privateDatabase = container.privateCloudDatabase

        do {
            let recordToMatch = CKRecord.Reference(recordID: userInfo.cloudKitID, action: .deleteSelf)
            let retrievedRecords = try await privateDatabase.records(matching: CKQuery(
                recordType: FavoriteJokeRecordKeys.type,
                predicate: NSPredicate(value: true))
            )

            var favoriteJokes: [FavoriteJoke] = []

            retrievedRecords.matchResults.forEach { recordID, result in
                switch result {
                case .success(let favoriteJokeRecord):
                    let favoriteJoke = FavoriteJoke(
                        cloudKitID: recordID,
                        owningUser: recordToMatch,
                        setup: favoriteJokeRecord[FavoriteJokeRecordKeys.setup] as! String,
                        setupAuthor: favoriteJokeRecord[FavoriteJokeRecordKeys.setupAuthor] as! String,
                        punchline: favoriteJokeRecord[FavoriteJokeRecordKeys.punchline] as! String,
                        punchlineAuthor: favoriteJokeRecord[FavoriteJokeRecordKeys.punchlineAuthor] as! String,
                        dateCreated: favoriteJokeRecord[FavoriteJokeRecordKeys.dateCreated] as! Date
                    )
                    favoriteJokes.append(favoriteJoke)
                case .failure:
                    break
                }
            }

            return favoriteJokes

        } catch {
            return []
        }

    }

    class func delete(favoriteJoke: FavoriteJoke) async {
        let privateDatabase = container.privateCloudDatabase

        do {
            let retrievedRecords = try await privateDatabase.records(for: [favoriteJoke.cloudKitID])
            let retrievedFavoriteJokeID = retrievedRecords.first?.0
            if let favoriteJokeID = retrievedFavoriteJokeID {
                try await privateDatabase.deleteRecord(withID: favoriteJokeID)
            }
        } catch {
            return
        }
    }

    // MARK: PunchLineLauncher

    class func getPublicPunchLineLauncher(for scope: PunchLineScope, locationName: String) async -> PunchLineLauncher? {
        let publicDatabase = container.publicCloudDatabase
        let publicPunchLineLauncherName = scope.rawValue + "." + locationName
        var matchedPunchLineLauncher: PunchLineLauncher?
        var matchedPunchLineLauncherRecord: CKRecord?

        do {
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                recordType: PunchLineLauncherRecordKeys.type,
                predicate: NSPredicate(format: "identifier = '\(publicPunchLineLauncherName)'"))
            )

            let _ = retrievedRecords.matchResults.first { _, result in
                switch result {
                case .success(let record):
                    matchedPunchLineLauncherRecord = record
                    matchedPunchLineLauncher = PunchLineLauncher(
                        cloudKitID: record.recordID,
                        owningUser: nil,
                        participantUserIDs: nil,
                        identifier: record[PunchLineLauncherRecordKeys.identifier] as! String,
                        displayName: record[PunchLineLauncherRecordKeys.displayName] as! String,
                        scope: PunchLineScope(rawValue: record[PunchLineLauncherRecordKeys.scope] as! String)!,
                        lastDailyResetDate: record[PunchLineLauncherRecordKeys.lastDailyResetDate] as! Date
                    )
                    return true
                case .failure:
                    return false
                }
            }

            if let matchedPunchLineLauncher, let matchedPunchLineLauncherRecord {
                if !Calendar.current.isDate(Date.now, inSameDayAs: matchedPunchLineLauncher.lastDailyResetDate) {
                    await removePunchLines(from: matchedPunchLineLauncher)
                    matchedPunchLineLauncherRecord[PunchLineLauncherRecordKeys.lastDailyResetDate] = Date() as CKRecordValue
                    try await publicDatabase.save(matchedPunchLineLauncherRecord)
                }
            }

            return matchedPunchLineLauncher
        } catch {
            return nil
        }
    }

    class func createNewPublicPunchLineLauncher(for scope: PunchLineScope, locationName: String) async -> PunchLineLauncher? {
        let publicDatabase = container.publicCloudDatabase

        let launcherRecord = CKRecord(recordType: PunchLineLauncherRecordKeys.type)
        launcherRecord[PunchLineLauncherRecordKeys.identifier] = (scope.rawValue + "." + locationName) as CKRecordValue
        launcherRecord[PunchLineLauncherRecordKeys.displayName] = locationName as CKRecordValue
        launcherRecord[PunchLineLauncherRecordKeys.scope] = scope.rawValue as CKRecordValue
        launcherRecord[PunchLineLauncherRecordKeys.lastDailyResetDate] = Date() as CKRecordValue

        do {
            try await publicDatabase.save(launcherRecord)
            let newPublicPunchLineLauncher = PunchLineLauncher(
                cloudKitID: launcherRecord.recordID,
                owningUser: nil,
                participantUserIDs: nil,
                identifier: launcherRecord[PunchLineLauncherRecordKeys.identifier] as! String,
                displayName: launcherRecord[PunchLineLauncherRecordKeys.displayName] as! String,
                scope: PunchLineScope(rawValue: launcherRecord[PunchLineLauncherRecordKeys.scope] as! String)!,
                lastDailyResetDate: launcherRecord[PunchLineLauncherRecordKeys.lastDailyResetDate] as! Date
            )
            return newPublicPunchLineLauncher
        } catch {
            return nil
        }
    }

    class func createNewCustomPunchLineLauncher(with name: String, participantUserIDs: [String]) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            let launcherRecord = CKRecord(recordType: PunchLineLauncherRecordKeys.type)
            launcherRecord[PunchLineLauncherRecordKeys.owningUser] = try await CKRecord.Reference(recordID: container.userRecordID(), action: .deleteSelf)
            launcherRecord[PunchLineLauncherRecordKeys.participantUserIDs] = participantUserIDs as CKRecordValue
            launcherRecord[PunchLineLauncherRecordKeys.identifier] = (PunchLineScope.custom.rawValue + "." + name.removingSpaces()) as CKRecordValue
            launcherRecord[PunchLineLauncherRecordKeys.displayName] = name as CKRecordValue
            launcherRecord[PunchLineLauncherRecordKeys.scope] = PunchLineScope.custom.rawValue as CKRecordValue
            launcherRecord[PunchLineLauncherRecordKeys.lastDailyResetDate] = Date() as CKRecordValue
            try await publicDatabase.save(launcherRecord)
        } catch {
            return
        }
    }

    class func getOwnedCustomPunchLineLaunchers() async -> [PunchLineLauncher] {
        let publicDatabase = container.publicCloudDatabase
        var ownedCustomPunchLineLaunchers: [PunchLineLauncher] = []
        var ownedCustomPunchLineLauncherRecords: [CKRecord] = []

        do {
            let recordToMatch = try await CKRecord.Reference(recordID: container.userRecordID(), action: .deleteSelf)
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                recordType: PunchLineLauncherRecordKeys.type,
                predicate: NSPredicate(format: "owningUser == %@", recordToMatch))
            )

            retrievedRecords.matchResults.forEach { (recordID, result) in
                switch result {
                case .success(let launcherRecord):
                    ownedCustomPunchLineLauncherRecords.append(launcherRecord)
                    let ownedCustomLauncher = PunchLineLauncher(
                        cloudKitID: recordID,
                        owningUser: recordToMatch,
                        participantUserIDs: launcherRecord[PunchLineLauncherRecordKeys.participantUserIDs] as? [String] ?? [],
                        identifier: launcherRecord[PunchLineLauncherRecordKeys.identifier] as! String,
                        displayName: launcherRecord[PunchLineLauncherRecordKeys.displayName] as! String,
                        scope: .custom,
                        lastDailyResetDate: launcherRecord[PunchLineLauncherRecordKeys.lastDailyResetDate] as! Date
                    )
                    ownedCustomPunchLineLaunchers.append(ownedCustomLauncher)
                case .failure:
                    return
                }
            }

            for (index, ownedCustomPunchLineLauncher) in ownedCustomPunchLineLaunchers.enumerated() {
                if !Calendar.current.isDate(Date.now, inSameDayAs: ownedCustomPunchLineLauncher.lastDailyResetDate) {
                    await removePunchLines(from: ownedCustomPunchLineLauncher)
                    ownedCustomPunchLineLauncherRecords[index][PunchLineLauncherRecordKeys.lastDailyResetDate] = Date() as CKRecordValue
                    try await publicDatabase.save(ownedCustomPunchLineLauncherRecords[index])
                }
            }

            return ownedCustomPunchLineLaunchers
        } catch {
            return []
        }
    }

    class func getJoinedCustomPunchLineLaunchers() async -> [PunchLineLauncher] {
        let publicDatabase = container.publicCloudDatabase
        var joinedCustomPunchLineLaunchers: [PunchLineLauncher] = []
        var joinedCustomPunchLineLauncherRecords: [CKRecord] = []

        do {
            let recordToMatch = try await container.userRecordID().recordName
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                recordType: PunchLineLauncherRecordKeys.type,
                predicate: NSPredicate(format: "ANY participantUserIDs == %@", recordToMatch)
            ))

            retrievedRecords.matchResults.forEach { (recordID, result) in
                switch result {
                case .success(let launcherRecord):
                    joinedCustomPunchLineLauncherRecords.append(launcherRecord)
                    let ownedCustomLauncher = PunchLineLauncher(
                        cloudKitID: recordID,
                        owningUser: launcherRecord[PunchLineLauncherRecordKeys.owningUser] as? CKRecord.Reference,
                        participantUserIDs: launcherRecord[PunchLineLauncherRecordKeys.participantUserIDs] as? [String] ?? [],
                        identifier: launcherRecord[PunchLineLauncherRecordKeys.identifier] as! String,
                        displayName: launcherRecord[PunchLineLauncherRecordKeys.displayName] as! String,
                        scope: .custom,
                        lastDailyResetDate: launcherRecord[PunchLineLauncherRecordKeys.lastDailyResetDate] as! Date
                    )
                    joinedCustomPunchLineLaunchers.append(ownedCustomLauncher)
                case .failure:
                    return
                }
            }

            for (index, joinedCustomPunchLineLauncher) in joinedCustomPunchLineLaunchers.enumerated() {
                if !Calendar.current.isDate(Date.now, inSameDayAs: joinedCustomPunchLineLauncher.lastDailyResetDate) {
                    await removePunchLines(from: joinedCustomPunchLineLauncher)
                    joinedCustomPunchLineLauncherRecords[index][PunchLineLauncherRecordKeys.lastDailyResetDate] = Date() as CKRecordValue
                    try await publicDatabase.save(joinedCustomPunchLineLauncherRecords[index])
                }
            }

            return joinedCustomPunchLineLaunchers
        } catch {
            return []
        }
    }

    class func removePunchLineLauncher(launcher: PunchLineLauncher) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            try await publicDatabase.deleteRecord(withID: launcher.cloudKitID)
        } catch {
            return
        }

    }

    // MARK: PunchLine

    class func getPunchLines(for launcher: PunchLineLauncher) async -> [PunchLine] {
        let publicDatabase = container.publicCloudDatabase

        do {
            let recordToMatch = CKRecord.Reference(recordID: launcher.cloudKitID, action: .deleteSelf)
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                recordType: PunchLineRecordKeys.type,
                predicate: NSPredicate(format: "owningLauncher == %@", recordToMatch))
            )

            var punchLines: [PunchLine] = []

            retrievedRecords.matchResults.map { $0.0 }.forEach { recordID in
                let punchLine = PunchLine(
                    cloudKitID: recordID,
                    owningLauncher: recordToMatch,
                    displayName: launcher.displayName
                )
                punchLines.append(punchLine)
            }

            return punchLines

        } catch {
            return []
        }

    }

    class func createNewPunchLine(for launcher: PunchLineLauncher) async -> PunchLine? {
        let publicDatabase = container.publicCloudDatabase

        do {
            let punchLineRecord = CKRecord(recordType: PunchLineRecordKeys.type)
            punchLineRecord[PunchLineRecordKeys.owningLauncher] = CKRecord.Reference(recordID: launcher.cloudKitID, action: .deleteSelf)
            punchLineRecord[PunchLineRecordKeys.displayName] = launcher.displayName as CKRecordValue

            try await publicDatabase.save(punchLineRecord)

            let newPunchLine = PunchLine(
                cloudKitID: punchLineRecord.recordID,
                owningLauncher: CKRecord.Reference(recordID: launcher.cloudKitID, action: .deleteSelf),
                displayName: launcher.displayName
            )

            return newPunchLine
        } catch {
            return nil
        }

    }

    class func punchLineIsAvailable(punchLine: PunchLine) -> Bool {
        return true
    }

    class func removePunchLines(from launcher: PunchLineLauncher) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            let recordToMatch = CKRecord.Reference(recordID: launcher.cloudKitID, action: .deleteSelf)
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                recordType: PunchLineRecordKeys.type,
                predicate: NSPredicate(format: "owningLauncher == %@", recordToMatch)
            ))

            var punchLines: [PunchLine] = []

            retrievedRecords.matchResults.map { $0.0 }.forEach { recordID in
                let punchLine = PunchLine(
                    cloudKitID: recordID,
                    owningLauncher: recordToMatch,
                    displayName: launcher.displayName
                )
                punchLines.append(punchLine)
            }

            await createCompletedPunchLine(from: punchLines, launcher: launcher)
            for punchLine in punchLines {
                try await publicDatabase.deleteRecord(withID: punchLine.cloudKitID)
            }
            
        } catch {
            // TODO: Handle Error
        }

    }

    class func createCompletedPunchLine(from punchLines: [PunchLine], launcher: PunchLineLauncher) async {
        var allJokes: [Joke] = []

        for punchLine in punchLines {
            let jokes = await getJokes(for: punchLine)
            allJokes.append(contentsOf: jokes)
        }

        let jokesSortedByPopularity = allJokes.sorted { $0.baseRankingScore > $1.baseRankingScore }
        let topTenJokes = Array(jokesSortedByPopularity[0...9])

        let publicDatabase = container.publicCloudDatabase

        do {
            let completedPunchLineRecord = CKRecord(recordType: CompletedPunchLineRecordKeys.type)
            completedPunchLineRecord[CompletedPunchLineRecordKeys.displayName] = (punchLines.first?.displayName ?? "Missing Name") as CKRecordValue
            completedPunchLineRecord[CompletedPunchLineRecordKeys.scope] = launcher.scope.rawValue as CKRecordValue
            completedPunchLineRecord[CompletedPunchLineRecordKeys.launcherID] = launcher.cloudKitID.recordName as CKRecordValue
            completedPunchLineRecord[CompletedPunchLineRecordKeys.dateCompleted] = launcher.lastDailyResetDate as CKRecordValue
            completedPunchLineRecord[CompletedPunchLineRecordKeys.topTenSetUps] = topTenJokes.map { $0.setup } as CKRecordValue
            completedPunchLineRecord[CompletedPunchLineRecordKeys.topTenSetUpAuthors] = topTenJokes.map { $0.setupAuthor } as CKRecordValue
            completedPunchLineRecord[CompletedPunchLineRecordKeys.topTenPunchlines] = topTenJokes.map { $0.punchline } as CKRecordValue
            completedPunchLineRecord[CompletedPunchLineRecordKeys.topTenPunchlineAuthors] = topTenJokes.map { $0.punchlineAuthor } as CKRecordValue
            try await publicDatabase.save(completedPunchLineRecord)
        } catch {
            return
        }

    }

    class func getCompletedPunchLine(for launcher: PunchLineLauncher, date: Date) async -> CompletedPunchLine? {
        let publicDatabase = container.publicCloudDatabase

        let launcherIDPredicate = NSPredicate(format: "launcherID = '\(launcher.cloudKitID.recordName)'")

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date
        let datePredicate = NSPredicate(format: "dateCompleted >= %@ AND dateCompleted < %@", argumentArray: [startOfDay, endOfDay])

        do {
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                recordType: CompletedPunchLineRecordKeys.type,
                predicate: NSCompoundPredicate(type: .and, subpredicates: [launcherIDPredicate, datePredicate]))
            )

            let retrievedCompletedPunchLineResult = retrievedRecords.matchResults.first?.1

            switch retrievedCompletedPunchLineResult {
            case .success(let retrievedCompletedPunchLineRecord):
                let completedPunchLine = CompletedPunchLine(
                    cloudKitID: retrievedCompletedPunchLineRecord.recordID,
                    displayName: retrievedCompletedPunchLineRecord[CompletedPunchLineRecordKeys.displayName] as! String,
                    scope: PunchLineScope(rawValue: retrievedCompletedPunchLineRecord[PunchLineLauncherRecordKeys.scope] as! String)!,
                    launcherID: retrievedCompletedPunchLineRecord[CompletedPunchLineRecordKeys.launcherID] as! String,
                    dateCompleted: retrievedCompletedPunchLineRecord[CompletedPunchLineRecordKeys.dateCompleted] as! Date,
                    topTenSetUps: retrievedCompletedPunchLineRecord[CompletedPunchLineRecordKeys.topTenSetUps] as! [String],
                    topTenSetUpAuthors: retrievedCompletedPunchLineRecord[CompletedPunchLineRecordKeys.topTenSetUpAuthors] as! [String],
                    topTenPunchlines: retrievedCompletedPunchLineRecord[CompletedPunchLineRecordKeys.topTenPunchlines] as! [String],
                    topTenPunchlineAuthors: retrievedCompletedPunchLineRecord[CompletedPunchLineRecordKeys.topTenPunchlineAuthors] as! [String]
                )
                return completedPunchLine
            case .failure, .none:
                return nil
            }

        } catch {
            return nil
        }

    }
    
    // MARK: Setup

    class func addSetup(to punchLine: PunchLine, setup: String, author: String) async {

        let publicDatabase = container.publicCloudDatabase

        do {
            let setupRecord = CKRecord(recordType: SetupRecordKeys.type)
            setupRecord[SetupRecordKeys.owningPunchLine] = CKRecord.Reference(recordID: punchLine.cloudKitID, action: .deleteSelf)
            setupRecord[SetupRecordKeys.text] = setup as CKRecordValue
            setupRecord[SetupRecordKeys.author] = author as CKRecordValue
            setupRecord[SetupRecordKeys.totalInteractionsCount] = 0 as CKRecordValue
            setupRecord[SetupRecordKeys.isUnfunnyCount] = 0 as CKRecordValue
            setupRecord[SetupRecordKeys.isOffensiveCount] = 0 as CKRecordValue
            try await publicDatabase.save(setupRecord)
        } catch {
            return
        }

    }

    class func getSetups(for punchLine: PunchLine) async -> [Setup] {
        let publicDatabase = container.publicCloudDatabase

        do {
            let recordToMatch = CKRecord.Reference(recordID: punchLine.cloudKitID, action: .deleteSelf)
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                recordType: SetupRecordKeys.type,
                predicate: NSPredicate(format: "owningPunchLine == %@", recordToMatch))
            )

            var setupsToReturn: [Setup] = []

            retrievedRecords.matchResults.forEach { recordID, result in
                switch result {
                case .success(let setupRecord):
                    guard let setupRecordAuthor = setupRecord[SetupRecordKeys.author] as? String else { return }
                    guard let currentUsername = AppSessionManager.userInfo?.username else { return }
                    guard setupRecordAuthor != currentUsername else { return }

                    let setup = Setup(
                        cloudKitID: setupRecord.recordID,
                        owningPunchLine: setupRecord[SetupRecordKeys.owningPunchLine] as! CKRecord.Reference,
                        text: setupRecord[SetupRecordKeys.text] as! String,
                        author: setupRecordAuthor,
                        totalInteractionsCount: setupRecord[SetupRecordKeys.totalInteractionsCount] as! Int,
                        isUnfunnyCount: setupRecord[SetupRecordKeys.isUnfunnyCount] as! Int,
                        isOffensiveCount: setupRecord[SetupRecordKeys.isOffensiveCount] as! Int
                    )

                    setupsToReturn.append(setup)
                case .failure:
                    return
                }
            }

            return setupsToReturn

        } catch {
            return []
        }

    }

    class func update(setup: Setup, in punchLine: PunchLine) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            let retrievedRecords = try await publicDatabase.records(for: [setup.cloudKitID])
            let retrievedSetupRecordResult = retrievedRecords.first?.1

            switch retrievedSetupRecordResult {
            case .success(let retrievedSetupRecord):
                retrievedSetupRecord.setValue(setup.text, forKey: SetupRecordKeys.text)
                retrievedSetupRecord.setValue(setup.author, forKey: SetupRecordKeys.author)
                retrievedSetupRecord.setValue(setup.isUnfunnyCount, forKey: SetupRecordKeys.isUnfunnyCount)
                retrievedSetupRecord.setValue(setup.isOffensiveCount, forKey: SetupRecordKeys.isOffensiveCount)
                try await publicDatabase.save(retrievedSetupRecord)
            case .failure, .none:
                break
            }
        } catch {
            // TODO: Handle Error
        }

    }

    class func delete(setup: Setup, in punchLine: PunchLine) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            let retrievedRecords = try await publicDatabase.records(for: [setup.cloudKitID])
            let retrievedSetupID = retrievedRecords.first?.0
            if let setupID = retrievedSetupID {
                try await publicDatabase.deleteRecord(withID: setupID)
            }
        } catch {
            return
        }

    }

    // MARK: Joke

    class func addJoke(to punchLine: PunchLine, setup: String, setupAuthor: String, punchline: String, punchlineAuthor: String) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            let jokeRecord = CKRecord(recordType: JokeRecordKeys.type)
            jokeRecord[JokeRecordKeys.owningPunchLine] = CKRecord.Reference(recordID: punchLine.cloudKitID, action: .deleteSelf)
            jokeRecord[JokeRecordKeys.setup] = setup as CKRecordValue
            jokeRecord[JokeRecordKeys.setupAuthor] = setupAuthor as CKRecordValue
            jokeRecord[JokeRecordKeys.punchline] = punchline as CKRecordValue
            jokeRecord[JokeRecordKeys.punchlineAuthor] = punchlineAuthor as CKRecordValue
            jokeRecord[JokeRecordKeys.haCount] = 0 as CKRecordValue
            jokeRecord[JokeRecordKeys.mehCount] = 0 as CKRecordValue
            jokeRecord[JokeRecordKeys.ughCount] = 0 as CKRecordValue
            jokeRecord[JokeRecordKeys.isTooFunnyCount] = 0 as CKRecordValue
            jokeRecord[JokeRecordKeys.isOffensiveCount] = 0 as CKRecordValue
            try await publicDatabase.save(jokeRecord)
        } catch {
            return
        }

    }

    class func getJokes(for punchLine: PunchLine) async -> [Joke] {
        let publicDatabase = container.publicCloudDatabase

        do {
            let recordToMatch = CKRecord.Reference(recordID: punchLine.cloudKitID, action: .deleteSelf)
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                recordType: JokeRecordKeys.type,
                predicate: NSPredicate(format: "owningPunchLine == %@", recordToMatch))
            )

            var jokesToReturn: [Joke] = []

            retrievedRecords.matchResults.forEach { recordID, result in
                switch result {
                case .success(let jokeRecord):
                    guard let jokeRecordSetupAuthor = jokeRecord[JokeRecordKeys.setupAuthor] as? String else { return }
                    guard let jokeRecordPunchlineAuthor = jokeRecord[JokeRecordKeys.punchlineAuthor] as? String else { return }
                    guard let currentUsername = AppSessionManager.userInfo?.username else { return }
                    guard jokeRecordSetupAuthor != currentUsername else { return }
                    guard jokeRecordPunchlineAuthor != currentUsername else { return }

                    let joke = Joke(
                        cloudKitID: jokeRecord.recordID,
                        owningPunchLine: jokeRecord[JokeRecordKeys.owningPunchLine] as! CKRecord.Reference,
                        setup: jokeRecord[JokeRecordKeys.setup] as! String,
                        setupAuthor: jokeRecord[JokeRecordKeys.setupAuthor] as! String,
                        punchline: jokeRecord[JokeRecordKeys.punchline] as! String,
                        punchlineAuthor: jokeRecord[JokeRecordKeys.punchlineAuthor] as! String,
                        haCount: jokeRecord[JokeRecordKeys.haCount] as! Int,
                        mehCount: jokeRecord[JokeRecordKeys.mehCount] as! Int,
                        ughCount: jokeRecord[JokeRecordKeys.ughCount] as! Int,
                        isTooFunnyCount: jokeRecord[JokeRecordKeys.isTooFunnyCount] as! Int,
                        isOffensiveCount: jokeRecord[JokeRecordKeys.isOffensiveCount] as! Int
                    )

                    jokesToReturn.append(joke)
                case .failure:
                    return
                }
            }

            return jokesToReturn

        } catch {
            return []
        }

    }

    class func update(joke: Joke, in punchLine: PunchLine) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            let retrievedRecords = try await publicDatabase.records(for: [joke.cloudKitID])
            let retrievedJokeRecordResult = retrievedRecords.first?.1

            switch retrievedJokeRecordResult {
            case .success(let retrievedJokeRecord):
                retrievedJokeRecord.setValue(joke.setup, forKey: JokeRecordKeys.setup)
                retrievedJokeRecord.setValue(joke.setupAuthor, forKey: JokeRecordKeys.setupAuthor)
                retrievedJokeRecord.setValue(joke.punchline, forKey: JokeRecordKeys.punchline)
                retrievedJokeRecord.setValue(joke.punchlineAuthor, forKey: JokeRecordKeys.punchlineAuthor)
                retrievedJokeRecord.setValue(joke.haCount, forKey: JokeRecordKeys.haCount)
                retrievedJokeRecord.setValue(joke.mehCount, forKey: JokeRecordKeys.mehCount)
                retrievedJokeRecord.setValue(joke.ughCount, forKey: JokeRecordKeys.ughCount)
                retrievedJokeRecord.setValue(joke.isTooFunnyCount, forKey: JokeRecordKeys.isTooFunnyCount)
                retrievedJokeRecord.setValue(joke.isOffensiveCount, forKey: JokeRecordKeys.isOffensiveCount)
                try await publicDatabase.save(retrievedJokeRecord)
            case .failure, .none:
                break
            }
        } catch {
            // TODO: Handle Error
        }

    }

    class func delete(joke: Joke, in punchLine: PunchLine) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            let retrievedRecords = try await publicDatabase.records(for: [joke.cloudKitID])
            let retrievedJokeID = retrievedRecords.first?.0
            if let jokeID = retrievedJokeID {
                try await publicDatabase.deleteRecord(withID: jokeID)
            }
        } catch {
            return
        }

    }

}
