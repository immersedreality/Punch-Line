//
//  AppSessionManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import Foundation

final class AppSessionManager {

    static var userInfo: UserInfo? {
        return getUserInfo()
    }

    // MARK: User Initialization

    class func validateUserInfo() {
        if userInfo == nil {
            initializeUserInfo()
        }
    }

    private class func initializeUserInfo() {
        UserDefaults.standard.set(UUID().uuidString, forKey: UserDefaultsKeys.punchLineUserID)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastActivityDate)
        UserDefaults.standard.set([String: Int](), forKey: UserDefaultsKeys.todaysTaskCounts)
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.shouldSeeOffensiveContent)
    }

    // MARK: Set/Get

    private class func getUserInfo() -> UserInfo? {
        guard let punchLineUserID = UserDefaults.standard.value(forKey: UserDefaultsKeys.punchLineUserID) as? String else { return nil }
        let punchLineUserName = UserDefaults.standard.value(forKey: UserDefaultsKeys.punchLineUserName) as? String
        let lastActivityDate = UserDefaults.standard.value(forKey: UserDefaultsKeys.lastActivityDate) as? Date ?? Date()
        let todaysTaskCounts = UserDefaults.standard.value(forKey: UserDefaultsKeys.todaysTaskCounts) as? [String: Int] ?? [:]
        let shouldSeeOffensiveContent = UserDefaults.standard.value(forKey: UserDefaultsKeys.shouldSeeOffensiveContent) as? Bool ?? false

        let userInfo = UserInfo(
            punchLineUserID: punchLineUserID,
            punchLineUserName: punchLineUserName,
            lastActivityDate: lastActivityDate,
            todaysTaskCounts: todaysTaskCounts,
            shouldSeeOffensiveContent: shouldSeeOffensiveContent
        )

        return userInfo
    }

    private class func set(userInfo: UserInfo) {
        UserDefaults.standard.set(userInfo.punchLineUserID, forKey: UserDefaultsKeys.punchLineUserID)
        UserDefaults.standard.set(userInfo.punchLineUserName, forKey: UserDefaultsKeys.punchLineUserName)
        UserDefaults.standard.set(userInfo.lastActivityDate, forKey: UserDefaultsKeys.lastActivityDate)
        UserDefaults.standard.set(userInfo.todaysTaskCounts, forKey: UserDefaultsKeys.todaysTaskCounts)
        UserDefaults.standard.set(userInfo.shouldSeeOffensiveContent, forKey: UserDefaultsKeys.shouldSeeOffensiveContent)
    }

    // MARK: Update Methods
    
    private class func handleDateChange() {
        UserDefaults.standard.set([String: Int](), forKey: UserDefaultsKeys.todaysTaskCounts)
    }

    class func incrementTodaysTaskCount(for punchLineID: String) {
        guard let userInfo = userInfo else { return }
        var todaysTaskCounts = userInfo.todaysTaskCounts
        let newTaskCountForPunchLine = (todaysTaskCounts[punchLineID] ?? 0) + 1
        todaysTaskCounts[punchLineID] = newTaskCountForPunchLine
        UserDefaults.standard.set(todaysTaskCounts, forKey: UserDefaultsKeys.todaysTaskCounts)
    }

    class func toggleOffensiveContentFilter() {
        guard let userInfo = userInfo else { return }
        UserDefaults.standard.set(!userInfo.shouldSeeOffensiveContent, forKey: UserDefaultsKeys.shouldSeeOffensiveContent)
    }

}

