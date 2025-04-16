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

    static var shouldMockNetworkCalls: Bool = true

    // MARK: User Initialization

    class func validateUserInfo() {
        if userInfo == nil {
            initializeUserInfo()
        }
    }

    private class func initializeUserInfo() {
        UserDefaults.standard.set(UUID().uuidString, forKey: UserDefaultsKeys.punchLineUserID)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastActivityDate)
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.shouldSeeOffensiveContent)
    }

    // MARK: Set/Get

    private class func getUserInfo() -> UserInfo? {
        guard let punchLineUserID = UserDefaults.standard.value(forKey: UserDefaultsKeys.punchLineUserID) as? String else { return nil }
        let punchLineUserName = UserDefaults.standard.value(forKey: UserDefaultsKeys.punchLineUserName) as? String
        let lastActivityDate = UserDefaults.standard.value(forKey: UserDefaultsKeys.lastActivityDate) as? Date ?? Date()
        let todaysTaskCounts = UserDefaults.standard.value(forKey: UserDefaultsKeys.todaysTaskCounts) as? [String: Int] ?? [:]
        let shouldSeeOffensiveContent = UserDefaults.standard.value(forKey: UserDefaultsKeys.shouldSeeOffensiveContent) as? Bool ?? false

        var favoriteJokes: [FavoriteJoke]?
        if let favoriteJokesData = UserDefaults.standard.object(forKey: UserDefaultsKeys.favoriteJokes) as? Data {
            let decoder = JSONDecoder()
            favoriteJokes = try? decoder.decode([FavoriteJoke].self, from: favoriteJokesData)
        }

        let userInfo = UserInfo(
            punchLineUserID: punchLineUserID,
            punchLineUserName: punchLineUserName,
            lastActivityDate: lastActivityDate,
            todaysTaskCounts: todaysTaskCounts,
            shouldSeeOffensiveContent: shouldSeeOffensiveContent,
            favoriteJokes: favoriteJokes ?? []
        )

        return userInfo
    }

    class func performInitialDataFetches() async {
        await APIManager.getPublicPunchLines()
        LocalDataManager.shared.fetchedPublicPunchLines.forEach { TestDataManager.initializeTestJokeHistoryEntryGroups(for: $0.id) }
    }

    // MARK: Update Methods

    class func createTaskCountKey(for punchLineID: String) {
        guard let userInfo = userInfo else { return }
        var todaysTaskCounts = userInfo.todaysTaskCounts
        todaysTaskCounts[punchLineID] = 0
        UserDefaults.standard.set(todaysTaskCounts, forKey: UserDefaultsKeys.todaysTaskCounts)
    }

    class func incrementTodaysTaskCount(for punchLineID: String) {
        guard let userInfo = userInfo else { return }
        resetTaskCountsIfNecessary()
        var todaysTaskCounts = userInfo.todaysTaskCounts
        let newTaskCountForPunchLine = (todaysTaskCounts[punchLineID] ?? 0) + 1
        todaysTaskCounts[punchLineID] = newTaskCountForPunchLine
        UserDefaults.standard.set(todaysTaskCounts, forKey: UserDefaultsKeys.todaysTaskCounts)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastActivityDate)
    }

    class func resetTaskCountsIfNecessary() {
        guard let lastActivityDate = userInfo?.lastActivityDate else { return }
        let lastActivityStartOfDay = Calendar.current.startOfDay(for: lastActivityDate)
        let todayStartOfDay = Calendar.current.startOfDay(for: Date())

        if lastActivityStartOfDay < todayStartOfDay {
            UserDefaults.standard.set([String: Int](), forKey: UserDefaultsKeys.todaysTaskCounts)
        }
    }

    class func toggleOffensiveContentFilter() {
        guard let userInfo = userInfo else { return }
        UserDefaults.standard.set(!userInfo.shouldSeeOffensiveContent, forKey: UserDefaultsKeys.shouldSeeOffensiveContent)
    }

    class func addFavoriteJoke(from joke: Joke) {
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
    }

    class func removeFavoriteJoke(with id: String) {
        guard let userInfo = userInfo else { return }
        var favoriteJokes = userInfo.favoriteJokes
        favoriteJokes.removeAll { $0.id == id }
        let encoder = JSONEncoder()
        if let favoriteJokesData = try? encoder.encode(favoriteJokes) {
            UserDefaults.standard.set(favoriteJokesData, forKey: UserDefaultsKeys.favoriteJokes)
        }
    }

}

