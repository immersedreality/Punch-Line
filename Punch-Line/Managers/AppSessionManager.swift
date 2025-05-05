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

    static var punchLineRelaunchers: [String: PunchLineRelauncher] = [:]

    // MARK: Ads

    static var shouldShowAd: Bool = false
    static var adAppearanceFrequency: TimeInterval = 180
    static var adTimer = Timer()

    // MARK: Initialization

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

    class func initializeAdTimer() {
        DispatchQueue.main.async {
            adTimer = Timer.scheduledTimer(withTimeInterval: adAppearanceFrequency, repeats: true) { _ in
                let userHasPunchLinePro = userInfo?.hasPunchLinePro ?? false
                if !userHasPunchLinePro {
                    shouldShowAd = true
                }
            }
        }
    }

    // MARK: Getters

    private class func getUserInfo() -> UserInfo? {
        guard let punchLineUserID = UserDefaults.standard.value(forKey: UserDefaultsKeys.punchLineUserID) as? String else { return nil }
        let punchLineUsername = UserDefaults.standard.value(forKey: UserDefaultsKeys.punchLineUsername) as? String
        let hasPunchLinePro = UserDefaults.standard.value(forKey: UserDefaultsKeys.hasPunchLinePro) as? Bool ?? false
        let lastActivityDate = UserDefaults.standard.value(forKey: UserDefaultsKeys.lastActivityDate) as? Date ?? Date()
        let todaysTaskCounts = UserDefaults.standard.value(forKey: UserDefaultsKeys.todaysTaskCounts) as? [String: Int] ?? [:]
        let dailyTooFunnyReportsCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.dailyTooFunnyReportsCount) as? Int ?? 0
        let shouldSeeOffensiveContent = UserDefaults.standard.value(forKey: UserDefaultsKeys.shouldSeeOffensiveContent) as? Bool ?? false
        let userIsNotFunny  = UserDefaults.standard.value(forKey: UserDefaultsKeys.userIsNotFunny) as? Bool ?? false

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
            hasPunchLinePro: hasPunchLinePro,
            lastActivityDate: lastActivityDate,
            todaysTaskCounts: todaysTaskCounts,
            dailyTooFunnyReportsCount: dailyTooFunnyReportsCount,
            shouldSeeOffensiveContent: shouldSeeOffensiveContent,
            userIsNotFunny: userIsNotFunny,
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
            UserDefaults.standard.set(0, forKey: UserDefaultsKeys.dailyTooFunnyReportsCount)
        }
    }

    class func incrementDailyTooFunnyReportsCount() {
        guard let userInfo = userInfo else { return }
        let newReportsCount = userInfo.dailyTooFunnyReportsCount + 1
        UserDefaults.standard.set(newReportsCount, forKey: UserDefaultsKeys.dailyTooFunnyReportsCount)
    }

    class func toggleHasPunchLinePro() {
        guard let userInfo = userInfo else { return }
        UserDefaults.standard.set(!userInfo.shouldSeeOffensiveContent, forKey: UserDefaultsKeys.hasPunchLinePro)
    }

    class func toggleShouldSeeOffensiveContent() {
        guard let userInfo = userInfo else { return }
        UserDefaults.standard.set(!userInfo.shouldSeeOffensiveContent, forKey: UserDefaultsKeys.shouldSeeOffensiveContent)
    }

    class func toggleUserIsNotFunny() {
        guard let userInfo = userInfo else { return }
        UserDefaults.standard.set(!userInfo.userIsNotFunny, forKey: UserDefaultsKeys.userIsNotFunny)
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

enum NetworkEnvironment {
    case mock, test, dev, prod
}
