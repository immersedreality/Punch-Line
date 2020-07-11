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

struct ColorConstants {
    static let punchlinePink = UIColor(red: 217/255, green: 120/255, blue: 127/255, alpha: 1.0)
}

struct IgnoredProperties {
    static let baseRankingScore = "baseRankingScore"
    static let isOffensive = "isOffensive"
    static let totalUpvoteCount = "totalUpvoteCount"
    static let totalVoteCount = "totalVoteCount"
}

struct PrimaryKeys {
    static let id = "id"
    static let username = "username"
}

struct RealmSyncConstants {
    static let activityPath = "/activity"
    static let all = "*"
    static let historyPath = "/history"
    static let httpsPrefix = "https://"
    static let realmInstanceLink = "stinky-wiener-wagon.us2a.cloud.realm.io"
    static let realmsPrefix = "realms://"
    static let userPath = "/~/user"
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
    static let theWorld = "The World"
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

