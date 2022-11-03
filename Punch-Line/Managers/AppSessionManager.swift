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
            todaysPunchlines: [String](),
            todaysTaskCounts: [Int](),
            shouldSeeOffensiveContent: userInfo.shouldSeeOffensiveContent
        )

        Task {
            await CloudKitManager.update(userInfo: updatedUserInfo)
        }

        self.userInfo = updatedUserInfo
    }

    class func incrementTodaysTaskCount(for punchlineID: String) {
        guard let userInfo = userInfo else { return }

        var updatedPunchlines = userInfo.todaysPunchlines
        var updatedTaskCounts = userInfo.todaysTaskCounts

        if userInfo.todaysPunchlines.contains(punchlineID) {
            guard let punchlineToUpdateIndex = updatedPunchlines.firstIndex(of: punchlineID) else {
                return
            }
            var taskCountToIncrement = updatedTaskCounts[punchlineToUpdateIndex]
            taskCountToIncrement += 1
            updatedTaskCounts[punchlineToUpdateIndex] = taskCountToIncrement
        } else {
            updatedPunchlines.append(punchlineID)
            updatedTaskCounts.append(1)
        }

        let updatedUserInfo = UserInfo(
            cloudKitID: userInfo.cloudKitID,
            username: userInfo.username,
            lastSignInDate: userInfo.lastSignInDate,
            todaysPunchlines: updatedPunchlines,
            todaysTaskCounts: updatedTaskCounts,
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
            todaysPunchlines: userInfo.todaysPunchlines,
            todaysTaskCounts: userInfo.todaysTaskCounts,
            shouldSeeOffensiveContent: !userInfo.shouldSeeOffensiveContent
        )

        Task {
            await CloudKitManager.update(userInfo: updatedUserInfo)
        }

        self.userInfo = updatedUserInfo
    }

}
