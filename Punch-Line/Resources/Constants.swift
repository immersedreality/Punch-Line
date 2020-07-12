//
//  Constants.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

struct CellIdentifiers {
    static let jokeCell = "JokeCell"
    static let jokeHistoryCell = "JokeHistoryCell"
    static let newPunchLineCell = "NewPunchLineCell"
    static let proTipCell = "ProTipCell"
    static let punchLineCell = "PunchLineCell"
    static let toggleSettingCell = "ToggleSettingCell"
    static let userCell = "UserCell"
}

struct FlagActionTitles {
    static let flagJokeAsOffensive = "Flag joke as offensive"
    static let flagJokeAsTooFunny = "Flag joke as too funny"
    static let flagSetupAsOffensive = "Flag setup as offensive"
    static let flagSetupAsUnfunny = "Flag setup as unfunny"
}

struct IgnoredProperties {
    static let baseRankingScore = "baseRankingScore"
    static let customPunchLineLaunchers = "customPunchLineLaunchers"
    static let nameWithoutSpaces = "nameWithoutSpaces"
    static let isOffensive = "isOffensive"
    static let publicPunchLineLaunchers = "publicPunchLineLaunchers"
    static let realmPath = "realmPath"
    static let sharedInstance = "sharedInstance"
    static let sortValue = "sortValue"
    static let totalUpvoteCount = "totalUpvoteCount"
    static let totalVoteCount = "totalVoteCount"
    static let userAccessPath = "userAccessPath"
}

struct InfoDictionaryKeys {
    static let shouldInitializeNewCloudInstance = "shouldInitializeNewCloudInstance"
}

struct PrimaryKeys {
    static let appSessionKey = "PLAppSession"
    static let id = "id"
}

struct ProfileTitles {
    static let favoriteJokes = "Favorite Jokes"
    static let showOffensiveContent = "Show Offensive Content"
    static let yourSurvivingJokes = "Your Surviving Jokes"
}

struct RealmSyncConstants {
    static let all = "*"
    static let httpsPrefix = "https://"
    static let realmInstanceLink = "stinky-wiener-wagon.us2a.cloud.realm.io"
    static let realmsPrefix = "realms://"
    static let userPath = "/~/User"
}

struct RegionCodes {
    static let canada = "CA"
    static let unitedStates = "US"
}

struct RegionDisplayNames {
    static let country = "Country"
    static let stateOrProvince = "State/Province"
    static let city = "City"
}

struct SegueIdentifiers {
    static let embedJokeListViewControllerInContainerView = "EmbedJokeListViewControllerInContainerView"
    static let presentActivityFeedViewController = "PresentActivityFeedViewController"
    static let presentMainTabBarController = "PresentMainTabBarController"
    static let presentProfileViewController = "PresentProfileViewController"
    static let presentPunchLineEditorViewController = "PresentPunchLineEditorViewController"
    static let showActivityContainerViewController = "ShowActivityContainerViewController"
    static let showPasswordViewController = "ShowPasswordViewController"
    static let showUsernameViewController = "ShowUsernameViewController"
}

struct StoryboardNames {
    static let getStarted = "GetStarted"
    static let punchline = "Punchline"
    static let setup = "Setup"
    static let vote = "Vote"
}

struct TableViewActionTitles {
    static let delete = "Delete"
    static let favorite = "Favorite"
    static let leave = "Leave"
    static let remove = "Remove"
}

struct TableViewSectionTitles {
    static let thePublic = "The Public"
    static let whatMadeTheCut = "What Made The Cut?"
    static let yourGroups = "Your Groups"
}

struct UserAuthorizationConstants {
    static let databaseIssue = "There was an issue connecting you to the database."
    static let enterAPassword = "Enter a password:"
    static let enterAUsername = "Enter a username:"
    static let enterYourPassword = "Enter your password:"
    static let enterYourUsername = "Enter your username:"
    static let passwordIsTooShort = "Password must be six or more characters."
}

