//
//  Constants.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

struct AlertConstants {
    static let cantConnectToiCloudTitle = "Can't Connect to iCloud"
    static let cantConnectToiCloudMessage = "Please make sure you are signed into iCloud on this device and that Punch-Line has access permission.  \nSettings > Apple ID > iCloud > Apps Using iCloud > Punch-Line"
    static let confirmTitle = "Are you sure?"
    static let confirmDeletionMessage = "This will permanently delete your user info and any custom Punch-Lines you created."
    static let confirmUsernameMessage = "This cannot be changed later unless you delete all of your Punch-Line data."
}

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

struct ProfileTitles {
    static let favoriteJokes = "Favorite Jokes"
    static let showOffensiveContent = "Show Offensive Content"
    static let yourSurvivingJokes = "Your Surviving Jokes"
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

struct SceneConstants {
    static let defaultConfiguration = "Default Configuration"
}

struct SegueIdentifiers {
    static let embedJokeListViewControllerInContainerView = "EmbedJokeListViewControllerInContainerView"
    static let presentActivityFeedViewController = "PresentActivityFeedViewController"
    static let presentMainTabBarController = "PresentMainTabBarController"
    static let presentProfileViewController = "PresentProfileViewController"
    static let presentPunchLineEditorViewController = "PresentPunchLineEditorViewController"
    static let showActivityContainerViewController = "ShowActivityContainerViewController"
    static let showUsernameViewController = "ShowUsernameViewController"
}

struct StoryboardNames {
    static let getStarted = "GetStarted"
    static let main = "Main"
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
