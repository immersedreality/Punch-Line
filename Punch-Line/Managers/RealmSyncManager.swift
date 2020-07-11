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
        applyPublicPermissions(forRealmAt: RealmSyncConstants.defaultRealmPath) { (permissionsWereGranted) in
            if permissionsWereGranted {
                loginSync(completion: completion)
            } else {
                completion(false)
            }
        }
    }

    class func loginSync(completion: @escaping (Bool) -> Void) {
        let defaultPunchLinePath = RealmSyncConstants.defaultRealmPath
        let userPath = RealmSyncConstants.userIdentityPath + RealmSyncConstants.userPath

        var defaultPunchLineSyncedSuccessfully = false
        var userRealmSyncedSuccessfully = false

        realmSyncDispatchGroup.enter()
        initialSync(withRealmAt: defaultPunchLinePath) { (realmSyncedSuccessfully) in
            defaultPunchLineSyncedSuccessfully = realmSyncedSuccessfully
            realmSyncDispatchGroup.leave()
        }

        realmSyncDispatchGroup.enter()
        initialSync(withRealmAt: userPath) { (realmSyncedSuccessfully) in
            userRealmSyncedSuccessfully = realmSyncedSuccessfully
            realmSyncDispatchGroup.leave()
        }

        realmSyncDispatchGroup.notify(queue: .main) {
            completion(defaultPunchLineSyncedSuccessfully && userRealmSyncedSuccessfully)
        }

    }

    class func appLaunchBackgroundSync() {
        let loggedInUser = AppSessionManager.sharedInstance.getLoggedInUser()

        for realmPath in loggedInUser.publicPunchLinePaths {
            initialSync(withRealmAt: realmPath, completion: { _ in })
        }

        for realmPath in loggedInUser.customPunchLinePaths {
            initialSync(withRealmAt: realmPath, completion: { _ in })
        }

    }

    class func initialSync(withRealmAt accessPath: AccessPath, completion: @escaping (Bool) -> Void) {
        guard let configuration = RealmAccessManager.configureRealm(withRealmAt: accessPath) else { completion(false); return }
        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            completion(realm != nil && error == nil)
        }
    }

    private class func applyPublicPermissions(forRealmAt accessPath: AccessPath, completion: @escaping (Bool) -> Void) {
        guard let user = SyncUser.current else { completion(false); return }

        let defaultPunchLinePermission = SyncPermission(realmPath: accessPath, identity: RealmSyncConstants.all, accessLevel: .write)

        user.apply(defaultPunchLinePermission) { (error) in
            let permissionsAppliedSuccessfully = error == nil
            completion(permissionsAppliedSuccessfully)
        }
    }
    
}
