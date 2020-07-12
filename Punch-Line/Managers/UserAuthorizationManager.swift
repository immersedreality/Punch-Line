//
//  UserAuthorizationManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

final class UserAuthorizationManager {

    let authorizationMode: UserAuthorizationMode

    let authorizationURL = URL(string: RealmSyncConstants.httpsPrefix + RealmSyncConstants.realmInstanceLink)

    var username: String?
    var password: String?

    init(authorizationMode: UserAuthorizationMode) {
        self.authorizationMode = authorizationMode
    }

    func initiateUserLogin(completion: @escaping (Bool, String?) -> Void) {
        switch authorizationMode {
        case .newUser:
            attemptUserRegistration(completion: completion)
        case .returningUser:
            attemptUserLogin(completion: completion)
        }
    }

    func attemptUserRegistration(completion: @escaping (Bool, String?) -> Void) {
        guard let username = username, let password = password else { return }
        guard let authorizationURL = authorizationURL else { return }
        let credentials = SyncCredentials.usernamePassword(username: username, password: password, register: true)
        let newCloudInstanceNeedsInitialization = Bundle.main.object(forInfoDictionaryKey: InfoDictionaryKeys.shouldInitializeNewCloudInstance) as? Bool ?? false

        SyncUser.logIn(
            with: credentials,
            server: authorizationURL) { [weak self] (syncUser, error) in
                if let user = syncUser {
                    if user.isAdmin && newCloudInstanceNeedsInitialization {
                        self?.initialize(adminUser: user, completion: completion)
                    } else {
                        self?.initialize(user: user, completion: completion)
                    }
                } else {
                    completion(false, error?.localizedDescription)
                }
        }

    }
    
    func attemptUserLogin(completion: @escaping (Bool, String?) -> Void) {
        guard let username = username, let password = password else { return }
        guard let authorizationURL = authorizationURL else { return }
        let credentials = SyncCredentials.usernamePassword(username: username, password: password, register: false)
        let newCloudInstanceNeedsInitialization = Bundle.main.object(forInfoDictionaryKey: InfoDictionaryKeys.shouldInitializeNewCloudInstance) as? Bool ?? false

        SyncUser.logIn(
            with: credentials,
            server: authorizationURL) { [weak self] (syncUser, error) in
                if let user = syncUser {
                    if user.isAdmin && newCloudInstanceNeedsInitialization {
                        self?.initialize(adminUser: user, completion: completion)
                    } else {
                        self?.initialize(user: user, completion: completion)
                    }
                } else {
                    completion(false, error?.localizedDescription)
                }
        }

    }

    private func initialize(adminUser: SyncUser, completion: @escaping (Bool, String?) -> Void) {
        RealmSyncManager.adminLoginSync { [weak self] syncWasSuccessful in
            if syncWasSuccessful {
                self?.createAppUserAndAppSession(with: adminUser)
                completion(true, nil)
            } else {
                completion(false, UserAuthorizationConstants.databaseIssue)
            }
        }
    }

    private func initialize(user: SyncUser, completion: @escaping (Bool, String?) -> Void) {
        RealmSyncManager.loginSync { [weak self] syncWasSuccessful in
            if syncWasSuccessful {
                self?.createAppUserAndAppSession(with: user)
                completion(true, nil)
            } else {
                completion(false, UserAuthorizationConstants.databaseIssue)
            }
        }
    }

    private func createAppUserAndAppSession(with syncUser: SyncUser) {
        guard let userIdentity = syncUser.identity else { return }
        let accessPath = RealmSyncConstants.userIdentityPath + RealmSyncConstants.userPath
        let appSession = AppSession()

        if let appUser = RealmAccessManager.getObject(of: AppUser.self, with: userIdentity, fromRealmAt: accessPath) {
            let localUser = LocalRealmManager.createLocalCopyOf(object: appUser)
            appSession.loggedInUser = localUser
        } else {
            let newAppUser = AppUser()
            newAppUser.id = syncUser.identity ?? UUID().uuidString
            newAppUser.username = self.username ?? ""
            appSession.loggedInUser = newAppUser
            RealmAccessManager.createCopyOf(object: newAppUser, inRealmAt: accessPath)
        }

        LocalRealmManager.addOrUpdateLocalUnmanaged(object: appSession)
    }

    class func logOut() {
        guard let user = SyncUser.current else { return }
        user.logOut()
        NavigationManager.setRootViewControllerToGetStarted()
    }
    
}

enum UserAuthorizationMode {
    case newUser, returningUser
}
