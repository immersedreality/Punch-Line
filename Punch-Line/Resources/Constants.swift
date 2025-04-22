//
//  Constants.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/18/25.
//

import SwiftUI

struct ActivityFeedMessages {
    static let punchline = "Finish this joke with a killer punchline!"
    static let setupFirst = "Start a joke with a funny setup!"
    static let setupSecond = "Start another joke with an even funnier setup!"
    static let setupThird = "Start one more with your funniest setup yet!"
    static let setupBeyond = "Keep the setups coming!"
    static let setupEnd = "Setups must end with either a question mark (?) or an ellipsis (…)"
    static let vote = "Quick Question: Is This Funny?"
    static let weDoneGoofed = "We done goofed!  You're not supposed to see this!"
}

struct AppConstants {
    static let adUnitID = "ca-app-pub-7985623540006861/2831009017"
    static let testAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    static let testAPIDomain = "http://localhost:8080"
    static let BannedWords = ["fag", "fagging", "faggitt", "faggot", "faggs", "fagot", "fagots", "fags", "kike", "n1gga", "n1gger", "nigg3r", "nigg4h", "nigga", "niggah", "niggas", "niggaz", "nigger", "niggers", "tranny"]
}

struct ConfirmationDialogMessages {
    static let addToFavorites = "Add to Favorites"
    static let copyJoke = "Copy Joke for Easy Sharing"
    static let createNewPrivatePunchLine = "Create New Private Punch-Line"
    static let disbandPrivatePunchLine = "Disband Private Punch-Line"
    static let flagJokeAsOffensive = "Flag joke as offensive"
    static let flagJokeAsTooFunny = "Flag joke as too funny"
    static let flagSetupAsOffensive = "Flag setup as offensive"
    static let flagSetupAsUnfunny = "Flag setup as unfunny"
    static let joinPrivatePunchLine = "Join Private Punch-Line"
    static let leavePrivatePunchLine = "Leave Private Punch-Line"
    static let removeFromFavorites = "Remove from Favorites"
    static let shareMessage = "(Shared from Punch-Line)"
}

struct ImageTitles {
    static let iconNavigationTitle = "Icon-NavigationTitle"
    static let logo = "Logo"
}

struct MockRequestTitles {
    static let getEntryGroups = "GET-EntryGroups"
    static let getPrivatePunchLines = "GET-PrivatePunchLines"
    static let getPublicPunchLines = "GET-PublicPunchLines"
}

struct NavigationTitles {
    static let favoriteJokes = "Funny Faves"
    static let joinedPrivatePunchLines = "Joined"
    static let jokeHistoryEntries = "Droll Days"
    static let jokeHistoryMonths = "Mirth Months"
    static let jokeHistoryPunchLines = "Humor History"
    static let jokeHistoryYears = "Yuk Years"
    static let jokeLookup = "Laugh Lookup"
    static let ownedPrivatePunchLines = "Owned"
    static let punchLineLaunchers = "Comedy Creation"
}

struct SystemIcons {
    static let addPunchLineButton = "plus"
    static let jokeHistoryTab = "clock.arrow.trianglehead.counterclockwise.rotate.90"
    static let jokeLookupTab = "magnifyingglass"
    static let punchLineLaunchersTab = "pencil.and.scribble"
    static let reportButton = "flag.fill"
    static let settingsButton = "gear"
}

struct UserDefaultsKeys {
    static let punchLineUserID = "PunchLineUserID"
    static let punchLineUserName = "PunchLineUserName"
    static let hasPunchLinePro = "HasPunchLinePro"
    static let lastActivityDate = "LastActivityDate"
    static let todaysTaskCounts = "TodaysTaskCounts"
    static let dailyTooFunnyReportsCount = "DailyTooFunnyReportsCount"
    static let shouldSeeOffensiveContent = "ShouldSeeOffensiveContent"
    static let favoriteJokes = "FavoriteJokes"
    static let ownedPrivatePunchLines = "OwnedPrivatePunchLines"
    static let joinedPrivatePunchLines = "JoinedPrivatePunchLines"
}
