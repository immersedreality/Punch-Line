//
//  Constants.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/18/25.
//

import SwiftUI

struct ActivityFeedMessages {
    static let punchlineLength = "Your punchline is too short. Try harder!"
    static let setupStartFirst = "Start a joke with a funny setup!"
    static let setupStartSecond = "Start another joke with an even funnier setup!"
    static let setupStartThird = "Start one more with your funniest setup yet!"
    static let setupStartBeyond = "Keep the setups coming!"
    static let setupLength = "Your setup is too short. Try harder!"
    static let setupEnd = "Setups must end with either a question mark (?) or an ellipsis (…)"
}

struct FlagActionTitles {
    static let cancel = "Cancel"
    static let flagJokeAsOffensive = "Flag joke as offensive"
    static let flagJokeAsTooFunny = "Flag joke as too funny"
    static let flagSetupAsOffensive = "Flag setup as offensive"
    static let flagSetupAsUnfunny = "Flag setup as unfunny"
}

struct ImageTitles {
    static let iconNavigationTitle = "Icon-NavigationTitle"
    static let logo = "Logo"
}

struct NavigationTitles {
    static let favoriteJokes = "Funny Faves"
    static let jokeHistoryEntries = "Droll Days"
    static let jokeHistoryMonths = "Mirth Months"
    static let jokeHistoryPunchLines = "Humor History"
    static let jokeHistoryYears = "Yuk Years"
    static let punchLineLaunchers = "Laugh Launchers"
}

struct SystemIcons {
    static let gear = "gear"
    static let jokeHistoryTab = "clock.arrow.trianglehead.counterclockwise.rotate.90"
    static let punchLineLaunchersTab = "pencil.and.scribble"
}

struct UserDefaultsKeys {
    static let punchLineUserID = "PunchLineUserID"
    static let punchLineUserName = "PunchLineUserName"
    static let lastActivityDate = "LastActivityDate"
    static let todaysTaskCounts = "TodaysTaskCounts"
    static let shouldSeeOffensiveContent = "ShouldSeeOffensiveContent"
    static let favoriteJokes = "FavoriteJokes"
}
