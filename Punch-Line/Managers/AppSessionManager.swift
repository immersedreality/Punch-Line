//
//  AppSessionManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

final class AppSessionManager {
    
    static var userInfo: UserInfo?
    static var currentPublicPunchlineLaunchers: [PunchLineLauncher] = []

    class func createNewUserInfo(with username: String) {
        let newUserInfo = UserInfo(
            username: username,
            shouldSeeOffensiveContent: true
        )

        Task {
            await CloudKitManager.saveNew(userInfo: newUserInfo)
        }

        self.userInfo = newUserInfo
    }

    class func restoreExistingUserInfo() async {
        let retrievedUserInfo = await CloudKitManager.getUserInfo()
        self.userInfo = retrievedUserInfo
    }

    class func toggleOffensiveContentFilter() {
        guard let userInfo = userInfo else { return }

        let updatedUserInfo = UserInfo(
            username: userInfo.username,
            shouldSeeOffensiveContent: !userInfo.shouldSeeOffensiveContent
        )

        Task {
            await CloudKitManager.update(userInfo: updatedUserInfo)
        }

        self.userInfo = updatedUserInfo
    }

}
