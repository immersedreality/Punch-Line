//
//  Constants.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

struct CellIdentifiers {
    static let newPunchLineCell = "NewPunchLineCell"
    static let punchLineCell = "PunchLineCell"
}

struct IgnoredProperties {
    static let baseRankingScore = "baseRankingScore"
    static let nameWithoutSpaces = "nameWithoutSpaces"
    static let isOffensive = "isOffensive"
    static let realmPath = "realmPath"
    static let sharedInstance = "sharedInstance"
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

struct SegueIdentifiers {
    static let presentMainTabBarController = "PresentMainTabBarController"
    static let presentProfileViewController = "PresentProfileViewController"
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

struct TableViewSectionTitles {
    static let thePublic = "The Public"
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

