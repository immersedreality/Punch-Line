//
//  UserInfo.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import Foundation

struct UserInfo {
    let punchLineUserID: String
    let punchLineUsername: String?
    let lastActivityDate: Date
    let todaysTaskCounts: [String: Int]
    let todaysSetupInteractionsIDs: [String: [String]]
    let todaysJokeInteractionsIDs: [String: [String]]
    let todaysTooFunnyReportsCount: Int
    let shouldSeeOffensiveContent: Bool
    let userIsNotFunny: Bool
    let userHasFatFingers: Bool
    let favoriteJokes: [FavoriteJoke]
    let ownedPrivatePunchLines: [PrivatePunchLine]
    let joinedPrivatePunchLines: [PrivatePunchLine]
}
