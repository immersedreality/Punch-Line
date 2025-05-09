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
    let dailyTooFunnyReportsCount: Int
    let shouldSeeOffensiveContent: Bool
    let userIsNotFunny: Bool
    let favoriteJokes: [FavoriteJoke]
    let ownedPrivatePunchLines: [PrivatePunchLine]
    let joinedPrivatePunchLines: [PrivatePunchLine]
}
