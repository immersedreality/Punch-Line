//
//  RealmSyncManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmSyncManager {

    typealias AccessPath = String

    private static let realmSyncDispatchGroup = DispatchGroup()

    class func adminLoginSync(completion: @escaping (Bool) -> Void) {
        let publicPunchLinesForNewCloudInstance = PunchLineSyncManager.generatePublicPunchLinesForNewCloudInstance()

        for punchLine in publicPunchLinesForNewCloudInstance {
            realmSyncDispatchGroup.enter()
            initialSync(withRealmAt: punchLine.realmPath) { (realmSyncedSuccessfully) in
                guard realmSyncedSuccessfully else { completion(false); return }
                applyPublicPermissions(forRealmAt: punchLine.realmPath) { (permissionsAppliedSuccessfully) in
                    guard permissionsAppliedSuccessfully else { completion(false); return }
                    RealmAccessManager.addOrUpdateUnmanaged(object: punchLine, inRealmAt: punchLine.realmPath)
                    realmSyncDispatchGroup.leave()
                }
            }
        }

        realmSyncDispatchGroup.notify(queue: .main) {
            completion(true)
        }

    }

    class func loginSync(completion: @escaping (Bool) -> Void) {

        let userPath = RealmSyncConstants.userIdentityPath + RealmSyncConstants.userPath
        var allRealmsSyncedSuccessfully = false

        realmSyncDispatchGroup.enter()
        initialSync(withRealmAt: userPath) { (realmSyncedSuccessfully) in
            allRealmsSyncedSuccessfully = realmSyncedSuccessfully
            realmSyncDispatchGroup.leave()
        }

        let regionCode = Locale.current.regionCode
        if regionCode == RegionCodes.unitedStates || regionCode == RegionCodes.canada {

            allRealmsSyncedSuccessfully = false
            let publicRegionPath = "/" + PublicPunchLineNames.MajorRegions.usAndCanada.removingSpaces()

            realmSyncDispatchGroup.enter()
            initialSync(withRealmAt: publicRegionPath) { (realmSyncedSuccessfully) in
                allRealmsSyncedSuccessfully = realmSyncedSuccessfully
                realmSyncDispatchGroup.leave()
            }

        }

        realmSyncDispatchGroup.notify(queue: .main) {
            completion(allRealmsSyncedSuccessfully)
        }

    }

    class func appLaunchBackgroundSync() {
        guard let loggedInUser = AppSession.sharedInstance.loggedInUser else { return }

        for realmPath in loggedInUser.publicPunchLinePaths {
            initialSync(withRealmAt: realmPath, completion: { _ in })
        }

        for realmPath in loggedInUser.customPunchLinePaths {
            initialSync(withRealmAt: realmPath, completion: { _ in })
        }

    }

    class func initialSync(withRealmAt accessPath: AccessPath, completion: @escaping (Bool) -> Void) {
        guard let configuration = RealmAccessManager.configureSyncedRealm(withRealmAt: accessPath) else { completion(false); return }
        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            completion(realm != nil && error == nil)
        }
    }

    class func sync(with punchLineNames: [String], completion: @escaping (Bool) -> Void) {
        for name in punchLineNames {
            realmSyncDispatchGroup.enter()
            initialSync(withRealmAt: name.removingSpaces()) { (_) in
                realmSyncDispatchGroup.leave()
            }
        }

        realmSyncDispatchGroup.notify(queue: .main) {
            completion(true)
        }

    }

    private class func applyPublicPermissions(forRealmAt accessPath: AccessPath, completion: @escaping (Bool) -> Void) {
        guard let user = SyncUser.current else { completion(false); return }

        let permission = SyncPermission(realmPath: accessPath, identity: RealmSyncConstants.all, accessLevel: .write)

        user.apply(permission) { (error) in
            let permissionsAppliedSuccessfully = error == nil
            completion(permissionsAppliedSuccessfully)
        }
    }
    
}
