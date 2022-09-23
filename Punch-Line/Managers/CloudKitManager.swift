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
        userInfoRecord[UserInfoRecordKeys.submittedDailySetupsCount] = 0 as CKRecordValue
        userInfoRecord[UserInfoRecordKeys.shouldSeeOffensiveContent] = true as CKRecordValue

        do {
            try await privateDatabase.save(userInfoRecord)
            await addUsernameToUserbase(username: username)
            return UserInfo(
                cloudKitID: userInfoRecord.recordID,
                username: userInfoRecord[UserInfoRecordKeys.username] as! String,
                lastSignInDate: userInfoRecord[UserInfoRecordKeys.lastSignInDate] as! Date,
                submittedDailySetupsCount: userInfoRecord[UserInfoRecordKeys.submittedDailySetupsCount] as! Int,
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
                    submittedDailySetupsCount: retrievedUserInfoRecord[UserInfoRecordKeys.submittedDailySetupsCount] as! Int,
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
            let retrievedRecords = try await privateDatabase.records(matching: CKQuery(recordType: UserInfoRecordKeys.type, predicate: NSPredicate(value: true)))
            let retrievedUserInfoResult = retrievedRecords.matchResults.first?.1

            switch retrievedUserInfoResult {
            case .success(let retrievedUserInfoRecord):
                retrievedUserInfoRecord.setValue(userInfo.username, forKey: UserInfoRecordKeys.username)
                retrievedUserInfoRecord.setValue(userInfo.lastSignInDate, forKey: UserInfoRecordKeys.lastSignInDate)
                retrievedUserInfoRecord.setValue(userInfo.submittedDailySetupsCount, forKey: UserInfoRecordKeys.submittedDailySetupsCount)
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

    class func addFavoriteJoke(to userInfo: UserInfo) {

    }

    class func getFavoriteJokes(for userInfo: UserInfo) {

    }

    class func removeFavoriteJoke(from userInfo: UserInfo) {

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

    class func getCustomPunchLineLauncher() {

    }

    class func createNewCustomPunchLineLauncher() {

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

    class func addSetup(to punchLine: PunchLine) {

    }

    class func getSetup(from punchLine: PunchLine) {

    }

    class func removeSetup(from punchLine: PunchLine) {

    }

    // MARK: Joke

    class func addJoke(to punchLine: PunchLine) {

    }

    class func getJoke(from punchLine: PunchLine) {

    }

    class func removeJoke(from punchLine: PunchLine) {

    }

}
