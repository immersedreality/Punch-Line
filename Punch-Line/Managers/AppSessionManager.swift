//
//  AppSessionManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

final class AppSessionManager {

    static let sharedInstance = AppSessionManager()

    private var loggedInUser: LocalUser!

    func set(loggedInUser: LocalUser) {
        self.loggedInUser = loggedInUser
    }

    func getLoggedInUser() -> LocalUser {
        return self.loggedInUser
    }

}
