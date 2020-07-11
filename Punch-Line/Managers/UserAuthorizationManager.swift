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

        SyncUser.logIn(
            with: credentials,
            server: authorizationURL) { [weak self] (syncUser, error) in
                if let user = syncUser {
                    if user.isAdmin {
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

        SyncUser.logIn(
            with: credentials,
            server: authorizationURL) { [weak self] (syncUser, error) in
                if let user = syncUser {
                    if user.isAdmin {
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
                self?.createLocalUserAndAppSession(with: adminUser)
                completion(true, nil)
            } else {
                completion(false, UserAuthorizationConstants.databaseIssue)
            }
        }
    }

    private func initialize(user: SyncUser, completion: @escaping (Bool, String?) -> Void) {
        RealmSyncManager.loginSync { [weak self] syncWasSuccessful in
            if syncWasSuccessful {
                self?.createLocalUserAndAppSession(with: user)
                completion(true, nil)
            } else {
                completion(false, UserAuthorizationConstants.databaseIssue)
            }
        }
    }

    private func createLocalUserAndAppSession(with user: SyncUser) {
        let localUser = LocalUser()
        localUser.id = user.identity ?? UUID().uuidString
        localUser.username = self.username ?? ""

        let appSession = AppSession()
        appSession.loggedInUser = localUser
        LocalRealmManager.addOrUpdateLocalUnmanaged(object: appSession)

        let accessPath = RealmSyncConstants.userIdentityPath + RealmSyncConstants.userPath
        RealmAccessManager.createCopyOf(object: localUser, inRealmAt: accessPath)
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
