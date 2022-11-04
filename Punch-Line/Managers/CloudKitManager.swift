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

    class func addFavorite(joke: Joke, to userInfo: UserInfo) async {
        let privateDatabase = container.privateCloudDatabase

        do {
            let favoriteJokeRecord = CKRecord(recordType: FavoriteJokeRecordKeys.type)
            favoriteJokeRecord[FavoriteJokeRecordKeys.owningUser] = CKRecord.Reference(recordID: userInfo.cloudKitID, action: .deleteSelf)
            favoriteJokeRecord[FavoriteJokeRecordKeys.setup] = joke.setup as CKRecordValue
            favoriteJokeRecord[FavoriteJokeRecordKeys.setupAuthor] = joke.setupAuthor as CKRecordValue
            favoriteJokeRecord[FavoriteJokeRecordKeys.punchline] = joke.punchline as CKRecordValue
            favoriteJokeRecord[FavoriteJokeRecordKeys.punchlineAuthor] = joke.punchlineAuthor as CKRecordValue
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
                        punchlineAuthor: favoriteJokeRecord[FavoriteJokeRecordKeys.punchlineAuthor] as! String
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

        do {
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                recordType: PunchLineLauncherRecordKeys.type,
                predicate: NSPredicate(format: "identifier = '\(publicPunchLineLauncherName)'"))
            )

            let _ = retrievedRecords.matchResults.first { _, result in
                switch result {
                case .success(let record):
                    matchedPunchLineLauncher = PunchLineLauncher(
                        cloudKitID: record.recordID,
                        owningUser: nil,
                        identifier: record[PunchLineLauncherRecordKeys.identifier] as! String,
                        displayName: record[PunchLineLauncherRecordKeys.displayName] as! String,
                        scope: PunchLineScope(rawValue: record[PunchLineLauncherRecordKeys.scope] as! String)!
                    )
                    return true
                case .failure:
                    return false
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

        do {
            try await publicDatabase.save(launcherRecord)
            let newPublicPunchLineLauncher = PunchLineLauncher(
                cloudKitID: launcherRecord.recordID,
                owningUser: nil,
                identifier: launcherRecord[PunchLineLauncherRecordKeys.identifier] as! String,
                displayName: launcherRecord[PunchLineLauncherRecordKeys.displayName] as! String,
                scope: PunchLineScope(rawValue: launcherRecord[PunchLineLauncherRecordKeys.scope] as! String)!
            )
            return newPublicPunchLineLauncher
        } catch {
            return nil
        }
    }

    class func createNewCustomPunchLineLauncher(with name: String) async -> PunchLineLauncher? {
        guard let userInfoID = AppSessionManager.userInfo?.cloudKitID else { return nil }

        let privateDatabase = container.privateCloudDatabase

        do {
            let launcherRecordZone = CKRecordZone(zoneName: UUID().uuidString)
            try await privateDatabase.save(launcherRecordZone)

            let launcherRecordZoneShare = CKShare(recordZoneID: launcherRecordZone.zoneID)
            try await privateDatabase.save(launcherRecordZoneShare)
            
            let launcherRecord = CKRecord(
                recordType: PunchLineLauncherRecordKeys.type,
                recordID: CKRecord.ID(recordName: UUID().uuidString, zoneID: launcherRecordZone.zoneID)
            )

            launcherRecord[PunchLineLauncherRecordKeys.owningUser] = CKRecord.Reference(recordID: userInfoID, action: .deleteSelf)
            launcherRecord[PunchLineLauncherRecordKeys.identifier] = (PunchLineScope.custom.rawValue + "." + name.removingSpaces()) as CKRecordValue
            launcherRecord[PunchLineLauncherRecordKeys.displayName] = name as CKRecordValue
            launcherRecord[PunchLineLauncherRecordKeys.scope] = PunchLineScope.custom.rawValue as CKRecordValue

            let newCustomPunchLineLauncher = PunchLineLauncher(
                cloudKitID: launcherRecord.recordID,
                owningUser: launcherRecord[PunchLineLauncherRecordKeys.owningUser] as? CKRecord.Reference,
                identifier: launcherRecord[PunchLineLauncherRecordKeys.identifier] as! String,
                displayName: launcherRecord[PunchLineLauncherRecordKeys.displayName] as! String,
                scope: PunchLineScope(rawValue: launcherRecord[PunchLineLauncherRecordKeys.scope] as! String)!
            )
            
            return newCustomPunchLineLauncher
        } catch {
            return nil
        }
    }

    class func getOwnedCustomPunchLineLaunchers() async -> [PunchLineLauncher] {
        guard let userID = AppSessionManager.userInfo?.cloudKitID else { return [] }

        let privateDatabase = container.privateCloudDatabase
        var ownedCustomPunchLineLaunchers: [PunchLineLauncher] = []

        do {
            let recordToMatch = CKRecord.Reference(recordID: userID, action: .deleteSelf)
            let retrievedRecords = try await privateDatabase.records(matching: CKQuery(
                recordType: PunchLineLauncherRecordKeys.type,
                predicate: NSPredicate(format: "owningUser == %@", recordToMatch))
            )

            retrievedRecords.matchResults.forEach { (recordID, result) in
                switch result {
                case .success(let launcherRecord):
                    let ownedCustomLauncher = PunchLineLauncher(
                        cloudKitID: recordID,
                        owningUser: recordToMatch,
                        identifier: launcherRecord[PunchLineLauncherRecordKeys.identifier] as! String,
                        displayName: launcherRecord[PunchLineLauncherRecordKeys.displayName] as! String,
                        scope: .custom
                    )
                    ownedCustomPunchLineLaunchers.append(ownedCustomLauncher)
                case .failure:
                    return
                }
            }

            return ownedCustomPunchLineLaunchers
        } catch {
            return []
        }
    }

    class func getSharedCustomPunchLineLaunchers() {

    }

    class func removeCustomPunchLineLauncher() {

    }

    // MARK: PunchLine

    class func getPunchLines(for launcher: PunchLineLauncher) async -> [PunchLine] {

        switch launcher.scope {
        case .country, .stateOrProvince, .city:
            let publicDatabase = container.publicCloudDatabase
            
            do {
                let recordToMatch = CKRecord.Reference(recordID: launcher.cloudKitID, action: .deleteSelf)
                let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                    recordType: PublicPunchLineRecordKeys.type,
                    predicate: NSPredicate(format: "owningLauncher == %@", recordToMatch))
                )

                var publicPunchLines: [PublicPunchLine] = []

                retrievedRecords.matchResults.map { $0.0 }.forEach { recordID in
                    let publicPunchLine = PublicPunchLine(
                        cloudKitID: recordID,
                        owningLauncher: recordToMatch,
                        displayName: launcher.displayName
                    )
                    publicPunchLines.append(publicPunchLine)
                }

                return publicPunchLines

            } catch {
                return []
            }

        case .custom:
            return []
        }

    }

    class func createNewPublicPunchLine(for launcher: PunchLineLauncher) async -> PublicPunchLine? {
        let publicDatabase = container.publicCloudDatabase

        do {
            let publicPunchLineRecord = CKRecord(recordType: PublicPunchLineRecordKeys.type)
            publicPunchLineRecord[PublicPunchLineRecordKeys.owningLauncher] = CKRecord.Reference(recordID: launcher.cloudKitID, action: .deleteSelf)
            publicPunchLineRecord[PublicPunchLineRecordKeys.displayName] = launcher.displayName as CKRecordValue

            try await publicDatabase.save(publicPunchLineRecord)

            let newPublicPunchLine = PublicPunchLine(
                cloudKitID: publicPunchLineRecord.recordID,
                owningLauncher: CKRecord.Reference(recordID: launcher.cloudKitID, action: .deleteSelf),
                displayName: launcher.displayName
            )

            return newPublicPunchLine
        } catch {
            return nil
        }

    }

    class func createNewCustomPunchLine(for launcher: PunchLineLauncher) {

    }

    class func removePunchLine(from launcher: PunchLineLauncher) {

    }

    class func getItemCount(for punchLine: PunchLine) -> Int {
        return 0
    }

    // MARK: Setup

    class func addSetup(to punchLine: PunchLine, setup: String, author: String) async {

        if punchLine is PublicPunchLine {
            let publicDatabase = container.publicCloudDatabase

            do {
                let setupRecord = CKRecord(recordType: SetupRecordKeys.type)
                setupRecord[SetupRecordKeys.owningPunchLine] = CKRecord.Reference(recordID: punchLine.cloudKitID, action: .deleteSelf)
                setupRecord[SetupRecordKeys.text] = setup as CKRecordValue
                setupRecord[SetupRecordKeys.author] = author as CKRecordValue
                setupRecord[SetupRecordKeys.isUnfunnyCount] = 0 as CKRecordValue
                setupRecord[SetupRecordKeys.isOffensiveCount] = 0 as CKRecordValue
                try await publicDatabase.save(setupRecord)
            } catch {
                return
            }

        } else if punchLine is CustomPunchLine {
            return
        }

        return
    }

    class func getRandomSetup(from punchLine: PunchLine) async -> Setup? {

        if punchLine is PublicPunchLine {
            let publicDatabase = container.publicCloudDatabase

            do {
                let recordToMatch = CKRecord.Reference(recordID: punchLine.cloudKitID, action: .deleteSelf)
                let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                    recordType: SetupRecordKeys.type,
                    predicate: NSPredicate(format: "owningPunchLine == %@", recordToMatch))
                )

                guard retrievedRecords.matchResults.count > 0 else {
                    return nil
                }

                let randomIndex = Int.random(in: 0..<retrievedRecords.matchResults.count)

                switch retrievedRecords.matchResults[randomIndex].1 {
                case .success(let setupRecord):
                    return Setup(
                        cloudKitID: setupRecord.recordID,
                        owningPunchLine: setupRecord[SetupRecordKeys.owningPunchLine] as! CKRecord.Reference,
                        text: setupRecord[SetupRecordKeys.text] as! String,
                        author: setupRecord[SetupRecordKeys.author] as! String,
                        isUnfunnyCount: setupRecord[SetupRecordKeys.isUnfunnyCount] as! Int,
                        isOffensiveCount: setupRecord[SetupRecordKeys.isOffensiveCount] as! Int
                    )
                case .failure:
                    return nil
                }
            } catch {
                return nil
            }

        } else if punchLine is CustomPunchLine {
            return nil
        }

        return nil
    }

    class func update(setup: Setup, in punchLine: PunchLine) async {

        if punchLine is PublicPunchLine {
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

        } else if punchLine is CustomPunchLine {

        }

    }

    class func delete(setup: Setup, in punchLine: PunchLine) async {

        if punchLine is PublicPunchLine {
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

        } else if punchLine is CustomPunchLine {

        }

    }

    // MARK: Joke

    class func addJoke(to punchLine: PunchLine, setup: String, setupAuthor: String, punchline: String, punchlineAuthor: String) async {

        if punchLine is PublicPunchLine {
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

        } else if punchLine is CustomPunchLine {
            return
        }

        return
    }

    class func getRandomJoke(from punchLine: PunchLine) async -> Joke? {

        if punchLine is PublicPunchLine {
            let publicDatabase = container.publicCloudDatabase

            do {
                let recordToMatch = CKRecord.Reference(recordID: punchLine.cloudKitID, action: .deleteSelf)
                let retrievedRecords = try await publicDatabase.records(matching: CKQuery(
                    recordType: JokeRecordKeys.type,
                    predicate: NSPredicate(format: "owningPunchLine == %@", recordToMatch))
                )

                guard retrievedRecords.matchResults.count > 0 else {
                    return nil
                }

                let randomIndex = Int.random(in: 0..<retrievedRecords.matchResults.count)

                switch retrievedRecords.matchResults[randomIndex].1 {
                case .success(let jokeRecord):
                    return Joke(
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
                case .failure:
                    return nil
                }
            } catch {
                return nil
            }
            
        } else if punchLine is CustomPunchLine {
            return nil
        }

        return nil
    }

    class func update(joke: Joke, in punchLine: PunchLine) async {

        if punchLine is PublicPunchLine {
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

        } else if punchLine is CustomPunchLine {

        }

    }

    class func delete(joke: Joke, in punchLine: PunchLine) async {

        if punchLine is PublicPunchLine {
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

        } else if punchLine is CustomPunchLine {

        }

    }

}
