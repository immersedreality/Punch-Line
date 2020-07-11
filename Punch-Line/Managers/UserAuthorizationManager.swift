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
        RealmAccessManager.initialAdminSync { [weak self] syncWasSuccessful in
            if syncWasSuccessful {
                self?.createLoggedInUserInformation(with: adminUser, completion: { (creationWasSuccessful) in
                    if creationWasSuccessful {
                        completion(true, nil)
                    } else {
                        completion(false, UserAuthorizationConstants.databaseIssue)
                    }
                })
            } else {
                completion(false, UserAuthorizationConstants.databaseIssue)
            }
        }
    }

    private func initialize(user: SyncUser, completion: @escaping (Bool, String?) -> Void) {
        RealmAccessManager.initialSync { [weak self] syncWasSuccessful in
            if syncWasSuccessful {
                self?.createLoggedInUserInformation(with: user, completion: { (creationWasSuccessful) in
                    if creationWasSuccessful {
                        completion(true, nil)
                    } else {
                        completion(false, UserAuthorizationConstants.databaseIssue)
                    }
                })
                completion(true, nil)
            } else {
                completion(false, UserAuthorizationConstants.databaseIssue)
            }
        }
    }

    private func createLoggedInUserInformation(with user: SyncUser, completion: @escaping (Bool) -> Void) {
        let loggedInUserInformation = LoggedInUserInformation()
        loggedInUserInformation.username = self.username ?? ""
        RealmAccessManager.addOrUpdate(object: loggedInUserInformation, inRealmAt: .user) { (updateWasSuccessful) in
            completion(updateWasSuccessful)
        }
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
