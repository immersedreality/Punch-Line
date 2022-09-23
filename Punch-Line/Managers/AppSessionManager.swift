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

    class func canCreateNewUser(for username: String) async -> Bool {
        if let userbase = await CloudKitManager.getUserbase() {
            return !userbase.allUsernames.contains(username)
        } else {
            await CloudKitManager.generateNewUserbase(with: username)
            return true
        }
    }

    class func createNewUserInfo(with username: String) {
        Task {
            let userInfo = await CloudKitManager.saveNewUserInfo(with: username)
            self.userInfo = userInfo
        }
    }

    class func restoreExistingUserInfo() async {
        let retrievedUserInfo = await CloudKitManager.getUserInfo()
        self.userInfo = retrievedUserInfo
        if let lastSignInDate = retrievedUserInfo?.lastSignInDate {
            if !Calendar.current.isDate(Date.now, inSameDayAs: lastSignInDate) {
                handleDateChange()
            }
        }
    }

    private class func handleDateChange() {
        guard let userInfo = userInfo else { return }

        let updatedUserInfo = UserInfo(
            cloudKitID: userInfo.cloudKitID,
            username: userInfo.username,
            lastSignInDate: Date(),
            todaysTaskCount: 0,
            shouldSeeOffensiveContent: userInfo.shouldSeeOffensiveContent
        )

        Task {
            await CloudKitManager.update(userInfo: updatedUserInfo)
        }

        self.userInfo = updatedUserInfo
    }

    class func incrementTodaysTaskCount() {
        guard let userInfo = userInfo else { return }

        let updatedUserInfo = UserInfo(
            cloudKitID: userInfo.cloudKitID,
            username: userInfo.username,
            lastSignInDate: userInfo.lastSignInDate,
            todaysTaskCount: userInfo.todaysTaskCount + 1,
            shouldSeeOffensiveContent: userInfo.shouldSeeOffensiveContent
        )

        Task {
            await CloudKitManager.update(userInfo: updatedUserInfo)
        }

        self.userInfo = updatedUserInfo
    }

    class func toggleOffensiveContentFilter() {
        guard let userInfo = userInfo else { return }

        let updatedUserInfo = UserInfo(
            cloudKitID: userInfo.cloudKitID,
            username: userInfo.username,
            lastSignInDate: userInfo.lastSignInDate,
            todaysTaskCount: userInfo.todaysTaskCount,
            shouldSeeOffensiveContent: !userInfo.shouldSeeOffensiveContent
        )

        Task {
            await CloudKitManager.update(userInfo: updatedUserInfo)
        }

        self.userInfo = updatedUserInfo
    }

}
