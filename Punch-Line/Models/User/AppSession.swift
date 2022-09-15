//
//  AppSession.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

final class AppSession {
    
    static var user: User?
    static var currentPublicPunchlineLaunchers: [PunchLineLauncher] = []

    class func createNewUser(with username: String) {
        let newUser = User(
            username: username,
            shouldSeeOffensiveContent: true
        )
        CloudKitManager.saveUserToPrivateDatabase(user: newUser)
    }

}
