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

    class func saveNew(userInfo: UserInfo) async {
        let privateDatabase = container.privateCloudDatabase
        let userInfoRecord = userInfo.record

        do {
            try await privateDatabase.save(userInfoRecord)
        } catch {
            #warning("TODO: Handle error")
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
                    username: retrievedUserInfoRecord[UserInfoRecordKeys.username] as! String,
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
                retrievedUserInfoRecord.setValue(userInfo.shouldSeeOffensiveContent, forKey: UserInfoRecordKeys.shouldSeeOffensiveContent)
                try await privateDatabase.save(retrievedUserInfoRecord)
            case .failure, .none:
                break
            }
        } catch {
            #warning("TODO: Handle error")
        }

    }

    class func getPublicPunchLineLauncher(for scope: PunchLineScope, locationName: String) async -> PunchLineLauncher? {
        let publicDatabase = container.publicCloudDatabase
        let publicPunchLineLauncherName = scope.rawValue + "." + locationName
        var matchedPunchLineLauncher: PunchLineLauncher?

        do {
            let retrievedRecords = try await publicDatabase.records(matching: CKQuery(recordType: PunchLineLauncherRecordKeys.type, predicate: NSPredicate(value: true)))

            let matchedRecord = retrievedRecords.matchResults.first { _, result in
                switch result {
                case .success(let record):
                    if record[PunchLineLauncherRecordKeys.identifier] == publicPunchLineLauncherName {
                        matchedPunchLineLauncher = PunchLineLauncher(
                            identifier: record[PunchLineLauncherRecordKeys.identifier] as! String,
                            displayName: record[PunchLineLauncherRecordKeys.displayName] as! String,
                            scope: PunchLineScope(rawValue: record[PunchLineLauncherRecordKeys.scope] as! String)!
                        )
                        return true
                    } else {
                        return false
                    }
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
        let newPublicPunchLineLauncher = PunchLineLauncher(identifier: scope.rawValue + "." + locationName, displayName: locationName, scope: scope)
        let newPublicPunchLineLauncherRecord = newPublicPunchLineLauncher.record

        do {
            try await publicDatabase.save(newPublicPunchLineLauncherRecord)
            return newPublicPunchLineLauncher
        } catch {
            return nil
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
            #warning("TODO: Handle error")
        }
        
    }

}
