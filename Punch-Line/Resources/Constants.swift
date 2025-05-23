//
//  Constants.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/18/25.
//

import SwiftUI

struct ActivityFeedMessages {
    static let ownPunchlineFirst = "Now finish it with a killer punchline!"
    static let ownPunchlineSecond = "Punchline it up, yo!"
    static let ownPunchlineThird = "You know the drill, finish the joke!"
    static let ownPunchlineExtra = "Complete your joke!"
    static let punchline = "Here's a setup.  Add your own punchline!"
    static let punchlineGeneric = "Finish the joke!"
    static let setupFirst = "Start your joke with a funny setup!"
    static let setupSecond = "Now start a joke with an even funnier setup!"
    static let setupThird = "One more setup.  Make it the funniest yet!"
    static let setupEnd = "Setups must end with either a question mark (?) or an ellipsis (…)"
    static let setupExtra = "Keep the setups coming!"
    static let vote = "Quick Question: Is This Funny?"
    static let weDoneGoofed = "We done goofed!  You're not supposed to see this!"
}

struct AlertConstants {
    static let areYouHappyPunchline = "Are you happy with your punchline?"
    static let areYouHappySetup = "Are you happy with your setup?"
    static let coolIt = "Cool It!"
    static let disbandmentConfirmation = "This Punch-Line and all the jokes in it will be deleted.  This cannot be reversed."
    static let failure = "Failure!"
    static let mustEnterUsername = "You must enter a username on the settings screen before you can create Punch-Lines, dude."
    static let nah = "Nah"
    static let okeydoke = "Okeydoke"
    static let tooFunnyReports = "You only get ten Too Funny reports a day! Stop being so easy to please, you dingus! -Jeff"
    static let whoAreYou = "Who Are You?"
    static let yeah = "Yeah"
    static let youSure = "You Sure?"
}

struct AppConstants {
    static let adUnitID = "ca-app-pub-7985623540006861/2831009017"
    static let testAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    static let BannedWords = ["fag", "fagging", "faggitt", "faggot", "faggs", "fagot", "fagots", "fags", "kike", "n1gga", "n1gger", "nigg3r", "nigg4h", "nigga", "niggah", "niggas", "niggaz", "nigger", "niggers", "tranny"]
}

struct ConfirmationDialogMessages {
    static let addToFavorites = "Add to Favorites"
    static let copyJoinCode = "Copy Join Code"
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

struct HTTPMethods {
    static let delete = "DELETE"
    static let get = "GET"
    static let patch = "PATCH"
    static let post = "POST"
    static let put = "PUT"
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
    static let entertainmentError = "Entertainment Error"
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

struct RequestComponents {

    // MARK: Domains

    static let devAPIDomain = "http://localhost:8080"
    static let testAPIDomain = "https://punch-line-api-test-3dda11447a7b.herokuapp.com"
    static let prodAPIDomain = "https://punch-line-api-prod-dd9c3690479f.herokuapp.com"

    // MARK: Path Components

    static let fetch = "/fetch"
    static let ha = "/ha"
    static let jokehistoryentries = "/jokehistoryentries"
    static let jokehistoryentrygroups = "/jokehistoryentrygroups"
    static let jokes = "/jokes"
    static let meh = "/meh"
    static let offensive = "/offensive"
    static let privatepunchlines = "/privatepunchlines"
    static let publicpunchlines = "/publicpunchlines"
    static let setups = "/setups"
    static let survivingjokes = "/survivingjokes"
    static let toofunny = "/toofunny"
    static let ugh = "/ugh"
    static let unfunny = "/unfunny"

    // MARK: Params

    static let entryID = "?entryID="
    static let entryGroupIDs = "?entryGroupIDs="
    static let includeOffensiveContent = "&includeOffensiveContent="
    static let jokeID = "?jokeID="
    static let punchLineID = "?punchLineID="
    static let punchLineIDs = "?punchLineIDs="
    static let searchQuery = "?searchQuery="
    static let setupID = "?setupID="
    
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
    static let punchLineUsername = "PunchLineUsername"
    static let lastActivityDate = "LastActivityDate"
    static let todaysTaskCounts = "TodaysTaskCounts"
    static let todaysSetupInteractionIDs = "TodaysSetupInteractionIDs"
    static let todaysJokeInteractionIDs = "TodaysJokeInteractionsIDs"
    static let todaysTooFunnyReportsCount = "TodaysTooFunnyReportsCount"
    static let shouldSeeOffensiveContent = "ShouldSeeOffensiveContent"
    static let userIsNotFunny = "UserIsNotFunny"
    static let userHasFatFingers = "UserHasFatFingers"
    static let favoriteJokes = "FavoriteJokes"
    static let ownedPrivatePunchLines = "OwnedPrivatePunchLines"
    static let joinedPrivatePunchLines = "JoinedPrivatePunchLines"
}
