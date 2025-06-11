//
//  AppSessionManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import Foundation

final class AppSessionManager {

    // MARK: Globally Accessible Properties

    static var userInfo: UserInfo? {
        return getUserInfo()
    }

    static var userIsInTraining = false
    static var trainingTaskCount = 0 {
        didSet {
            if trainingTaskCount == 10 {
                userIsInTraining = false
            }
        }
    }

    static var punchLineRelaunchers: [String: PunchLineRelauncher] = [:]

    // MARK: Jeff Mode

    static let appIsInJeffMode = false

    // MARK: Ads

//    static var shouldShowAd: Bool = false
//    static var adAppearanceFrequency: TimeInterval = 180
//    static var adTimer = Timer()

    // MARK: Initialization

    class func validateUserInfo() {
        if userInfo == nil {
            initializeUserInfo()
        }
    }

    private class func initializeUserInfo() {
        UserDefaults.standard.set(UUID().uuidString, forKey: UserDefaultsKeys.punchLineUserID)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastActivityDate)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.shouldSeeOffensiveContent)
    }

//    class func setAdTimer() {
//        DispatchQueue.main.async {
//            adTimer = Timer.scheduledTimer(withTimeInterval: adAppearanceFrequency, repeats: false) { _ in
//                shouldShowAd = true
//            }
//        }
//    }

    // MARK: Getters

    private class func getUserInfo() -> UserInfo? {
        guard let punchLineUserID = UserDefaults.standard.value(forKey: UserDefaultsKeys.punchLineUserID) as? String else { return nil }
        let punchLineUsername = UserDefaults.standard.value(forKey: UserDefaultsKeys.punchLineUsername) as? String
        let lastActivityDate = UserDefaults.standard.value(forKey: UserDefaultsKeys.lastActivityDate) as? Date ?? Date()
        let todaysTaskCounts = UserDefaults.standard.value(forKey: UserDefaultsKeys.todaysTaskCounts) as? [String: Int] ?? [:]
        let todaysSetupInteractionIDs = UserDefaults.standard.value(forKey: UserDefaultsKeys.todaysSetupInteractionIDs) as? [String: [String]] ?? [:]
        let todaysJokeInteractionIDs = UserDefaults.standard.value(forKey: UserDefaultsKeys.todaysJokeInteractionIDs) as? [String: [String]] ?? [:]
        let todaysTooFunnyReportsCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.todaysTooFunnyReportsCount) as? Int ?? 0
        let userHasSeenExplainer = UserDefaults.standard.value(forKey: UserDefaultsKeys.userHasSeenExplainer) as? Bool ?? false
        let shouldSeeOffensiveContent = UserDefaults.standard.value(forKey: UserDefaultsKeys.shouldSeeOffensiveContent) as? Bool ?? false
        let userIsNotFunny = UserDefaults.standard.value(forKey: UserDefaultsKeys.userIsNotFunny) as? Bool ?? false
        let usersNameIsJerry = UserDefaults.standard.value(forKey: UserDefaultsKeys.usersNameIsJerry) as? Bool ?? false
        let userHasFatFingers = UserDefaults.standard.value(forKey: UserDefaultsKeys.userHasFatFingers) as? Bool ?? false

        var favoriteJokes: [FavoriteJoke]?
        if let favoriteJokesData = UserDefaults.standard.object(forKey: UserDefaultsKeys.favoriteJokes) as? Data {
            let decoder = JSONDecoder()
            favoriteJokes = try? decoder.decode([FavoriteJoke].self, from: favoriteJokesData)
        }

        var ownedPrivatePunchLines: [PrivatePunchLine]?
        if let ownedPrivatePunchLinesData = UserDefaults.standard.object(forKey: UserDefaultsKeys.ownedPrivatePunchLines) as? Data {
            let decoder = JSONDecoder()
            ownedPrivatePunchLines = try? decoder.decode([PrivatePunchLine].self, from: ownedPrivatePunchLinesData)
        }

        var joinedPrivatePunchLines: [PrivatePunchLine]?
        if let joinedPrivatePunchLinesData = UserDefaults.standard.object(forKey: UserDefaultsKeys.joinedPrivatePunchLines) as? Data {
            let decoder = JSONDecoder()
            joinedPrivatePunchLines = try? decoder.decode([PrivatePunchLine].self, from: joinedPrivatePunchLinesData)
        }

        let userInfo = UserInfo(
            punchLineUserID: punchLineUserID,
            punchLineUsername: punchLineUsername,
            lastActivityDate: lastActivityDate,
            todaysTaskCounts: todaysTaskCounts,
            todaysSetupInteractionsIDs: todaysSetupInteractionIDs,
            todaysJokeInteractionsIDs: todaysJokeInteractionIDs,
            todaysTooFunnyReportsCount: todaysTooFunnyReportsCount,
            userHasSeenExplainer: userHasSeenExplainer,
            shouldSeeOffensiveContent: shouldSeeOffensiveContent,
            userIsNotFunny: userIsNotFunny,
            usersNameIsJerry: usersNameIsJerry,
            userHasFatFingers: userHasFatFingers,
            favoriteJokes: favoriteJokes ?? [],
            ownedPrivatePunchLines: ownedPrivatePunchLines ?? [],
            joinedPrivatePunchLines: joinedPrivatePunchLines ?? []
        )

        return userInfo
    }

    class func taskCount(for punchLineID: String) -> Int {
        guard let taskCount = userInfo?.todaysTaskCounts[punchLineID] else {
            createTaskCountKey(for: punchLineID)
            return 0
        }
        return taskCount
    }

    class func setupInteractionIDs(for punchLineID: String) -> [String] {
        guard let setupIDs = userInfo?.todaysSetupInteractionsIDs[punchLineID] else {
            return []
        }
        return setupIDs
    }

    class func jokeInteractionIDs(for punchLineID: String) -> [String] {
        guard let jokeIDs = userInfo?.todaysJokeInteractionsIDs[punchLineID] else {
            return []
        }
        return jokeIDs
    }

    // MARK: Update Methods

    class func set(username: String) {
        UserDefaults.standard.set(username, forKey: UserDefaultsKeys.punchLineUsername)
    }

    class func createTaskCountKey(for punchLineID: String) {
        guard let userInfo = userInfo else { return }
        var todaysTaskCounts = userInfo.todaysTaskCounts
        todaysTaskCounts[punchLineID] = 0
        UserDefaults.standard.set(todaysTaskCounts, forKey: UserDefaultsKeys.todaysTaskCounts)
    }

    class func incrementTodaysTaskCount(for punchLineID: String) {
        guard let userInfo = userInfo else { return }
        resetDailyPropertiesIfNecessary()
        var todaysTaskCounts = userInfo.todaysTaskCounts
        let newTaskCountForPunchLine = (todaysTaskCounts[punchLineID] ?? 0) + 1
        todaysTaskCounts[punchLineID] = newTaskCountForPunchLine
        UserDefaults.standard.set(todaysTaskCounts, forKey: UserDefaultsKeys.todaysTaskCounts)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastActivityDate)
    }

    class func addSetup(interactionID: String, for punchLineID: String) {
        guard let userInfo = userInfo, interactionID != "" else { return }
        var todaysSetupInteractionIDs = userInfo.todaysSetupInteractionsIDs
        var setupInteractionIDsForPunchLine = todaysSetupInteractionIDs[punchLineID] ?? []
        if !setupInteractionIDsForPunchLine.contains(interactionID) {
            setupInteractionIDsForPunchLine.append(interactionID)
        }
        todaysSetupInteractionIDs[punchLineID] = setupInteractionIDsForPunchLine
        UserDefaults.standard.set(todaysSetupInteractionIDs, forKey: UserDefaultsKeys.todaysSetupInteractionIDs)
    }

    class func addJoke(interactionID: String, for punchLineID: String) {
        guard let userInfo = userInfo, interactionID != "" else { return }
        var todaysJokeInteractionIDs = userInfo.todaysJokeInteractionsIDs
        var jokeInteractionIDsForPunchLine = todaysJokeInteractionIDs[punchLineID] ?? []
        if !jokeInteractionIDsForPunchLine.contains(interactionID) {
            jokeInteractionIDsForPunchLine.append(interactionID)
        }
        todaysJokeInteractionIDs[punchLineID] = jokeInteractionIDsForPunchLine
        UserDefaults.standard.set(todaysJokeInteractionIDs, forKey: UserDefaultsKeys.todaysJokeInteractionIDs)
    }

    class func incrementTodaysTooFunnyReportsCount() {
        guard let userInfo = userInfo else { return }
        let newReportsCount = userInfo.todaysTooFunnyReportsCount + 1
        UserDefaults.standard.set(newReportsCount, forKey: UserDefaultsKeys.todaysTooFunnyReportsCount)
    }

    class func dailyPropertiesWillBeReset() -> Bool {
        guard let lastActivityDate = userInfo?.lastActivityDate else { return false }
        let lastActivityStartOfDay = Date.startOfDayInServerTime(from: lastActivityDate)
        let todayStartOfDay = Date.startOfDayInServerTime(from: Date())
        return lastActivityStartOfDay < todayStartOfDay
    }

    class func resetDailyPropertiesIfNecessary() {
        guard let lastActivityDate = userInfo?.lastActivityDate else { return }
        let lastActivityStartOfDay = Date.startOfDayInServerTime(from: lastActivityDate)
        let todayStartOfDay = Date.startOfDayInServerTime(from: Date())

        if lastActivityStartOfDay < todayStartOfDay {
            UserDefaults.standard.set([String: Int](), forKey: UserDefaultsKeys.todaysTaskCounts)
            UserDefaults.standard.set([String: [String]](), forKey: UserDefaultsKeys.todaysSetupInteractionIDs)
            UserDefaults.standard.set([String: [String]](), forKey: UserDefaultsKeys.todaysJokeInteractionIDs)
            UserDefaults.standard.set(0, forKey: UserDefaultsKeys.todaysTooFunnyReportsCount)
            punchLineRelaunchers = [:]
        }
    }

    class func toggleUserHasSeenExplainer() {
        guard let userInfo = userInfo else { return }
        UserDefaults.standard.set(!userInfo.userHasSeenExplainer, forKey: UserDefaultsKeys.userHasSeenExplainer)
    }

    class func toggleShouldSeeOffensiveContent() {
        guard let userInfo = userInfo else { return }
        UserDefaults.standard.set(!userInfo.shouldSeeOffensiveContent, forKey: UserDefaultsKeys.shouldSeeOffensiveContent)
    }

    class func setUserIsNotFunny(to newValue: Bool) {
        guard let userInfo = userInfo else { return }
        guard newValue != userInfo.userIsNotFunny else { return }
        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userIsNotFunny)
        if newValue == true && userInfo.usersNameIsJerry {
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.usersNameIsJerry)
            GlobalNotificationManager.shared.appModesHaveChanged = true
        }
    }

    class func setUsersNameIsJerry(to newValue: Bool) {
        guard let userInfo = userInfo else { return }
        guard newValue != userInfo.usersNameIsJerry else { return }
        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.usersNameIsJerry)
        if newValue == true && userInfo.userIsNotFunny {
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.userIsNotFunny)
            GlobalNotificationManager.shared.appModesHaveChanged = true
        }
    }

    class func toggleUserHasFatFingers() {
        guard let userInfo = userInfo else { return }
        UserDefaults.standard.set(!userInfo.userHasFatFingers, forKey: UserDefaultsKeys.userHasFatFingers)
    }

    class func addFavoriteJoke(from joke: SurvivingJoke) {
        guard let userInfo = userInfo else { return }
        var favoriteJokes = userInfo.favoriteJokes

        let favoriteJoke = FavoriteJoke(
            id: UUID().uuidString,
            originJokeID: joke.id,
            dateFavorited: Date(),
            setup: joke.setup,
            setupAuthorUsername: joke.setupAuthorUsername,
            punchline: joke.punchline,
            punchlineAuthorUsername: joke.punchlineAuthorUsername
        )

        favoriteJokes.append(favoriteJoke)
        
        let encoder = JSONEncoder()
        if let favoriteJokesData = try? encoder.encode(favoriteJokes) {
            UserDefaults.standard.set(favoriteJokesData, forKey: UserDefaultsKeys.favoriteJokes)
        }

        GlobalNotificationManager.shared.favoritesHaveBeenUpdated = true
    }

    class func removeFavoriteJoke(with id: String) {
        guard let userInfo = userInfo else { return }
        var favoriteJokes = userInfo.favoriteJokes
        favoriteJokes.removeAll { $0.id == id }
        let encoder = JSONEncoder()
        if let favoriteJokesData = try? encoder.encode(favoriteJokes) {
            UserDefaults.standard.set(favoriteJokesData, forKey: UserDefaultsKeys.favoriteJokes)
        }

        GlobalNotificationManager.shared.favoritesHaveBeenUpdated = true
    }

    class func add(privatePunchLine: PrivatePunchLine) {
        guard let userInfo = userInfo else { return }

        if privatePunchLine.owningUserID == userInfo.punchLineUserID {
            var ownedPrivatePunchLines = userInfo.ownedPrivatePunchLines
            ownedPrivatePunchLines.append(privatePunchLine)
            let encoder = JSONEncoder()
            if let ownedPrivatePunchLinesData = try? encoder.encode(ownedPrivatePunchLines) {
                UserDefaults.standard.set(ownedPrivatePunchLinesData, forKey: UserDefaultsKeys.ownedPrivatePunchLines)
            }
        } else {
            var joinedPrivatePunchLines = userInfo.joinedPrivatePunchLines
            joinedPrivatePunchLines.append(privatePunchLine)
            let encoder = JSONEncoder()
            if let joinedPrivatePunchLinesData = try? encoder.encode(joinedPrivatePunchLines) {
                UserDefaults.standard.set(joinedPrivatePunchLinesData, forKey: UserDefaultsKeys.joinedPrivatePunchLines)
            }
        }

    }

    class func removeOwnedPrivatePunchLine(with id: String) {
        guard let userInfo = userInfo else { return }
        var ownedPrivatePunchLines = userInfo.ownedPrivatePunchLines
        ownedPrivatePunchLines.removeAll { $0.id == id }
        let encoder = JSONEncoder()
        if let ownedPrivatePunchLinesData = try? encoder.encode(ownedPrivatePunchLines) {
            UserDefaults.standard.set(ownedPrivatePunchLinesData, forKey: UserDefaultsKeys.ownedPrivatePunchLines)
        }
    }

    class func removeJoinedPrivatePunchLine(with id: String) {
        guard let userInfo = userInfo else { return }
        var joinedPrivatePunchLines = userInfo.joinedPrivatePunchLines
        joinedPrivatePunchLines.removeAll { $0.id == id }
        let encoder = JSONEncoder()
        if let joinedPrivatePunchLinesData = try? encoder.encode(joinedPrivatePunchLines) {
            UserDefaults.standard.set(joinedPrivatePunchLinesData, forKey: UserDefaultsKeys.joinedPrivatePunchLines)
        }
    }

}
