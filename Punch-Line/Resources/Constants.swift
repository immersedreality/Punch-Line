//
//  Constants.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

struct ActivityFeedMessages {
    static let punchlineLength = "Your punchline is too short. Try harder!"
    static let setupStartFirst = "Start a joke with a funny setup!"
    static let setupStartSecond = "Start another joke with an even funnier setup!"
    static let setupStartThird = "Start one more with your funniest setup yet!"
    static let setupStartBeyond = "Keep the setups coming!"
    static let setupLength = "Your setup is too short. Try harder!"
    static let setupEnd = "Setups must end with either a question mark (?) or an ellipsis (…)"
}

struct AlertConstants {
    static let cantConnectToiCloudTitle = "Can't Connect to iCloud"
    static let cantConnectToiCloudMessage = "Please make sure you are signed into iCloud on this device and that Punch-Line has access permission.  \n\nSettings > Apple ID > iCloud > Apps Using iCloud > Punch-Line"
    static let confirmTitle = "Are you sure?"
    static let confirmDeletionMessage = "This will permanently delete your user info and any custom Punch-Lines you created."
    static let confirmUsernameMessage = "This cannot be changed later unless you delete all of your Punch-Line data."
    static let noAccountForContactTitle = "Could Not Find Account"
    static let noAccountForContactMessage = "Punch-Line accounts could not be found for one or more of your contacts.  \n\nPlease ensure their iCloud email matches the one in your contact card for them."
    static let notCurrentlyDiscoverableTitle = "Not Currently Discoverable"
    static let notCurrentlyDiscoverableMessage = "You are not currently discoverable by other Punch-Line users.  If you wish to create or join custom Punch-Lines you must enable the appropriate setting.  \n\nSettings > Apple ID > iCloud > Apps Using iCloud > Look Me Up"
    static let punchLineNeedsFriendsTitle = "No Added Friends"
    static let punchLineNeedsFriendsMessage = "You must add at least one friend to create a custom Punch-Line."
    static let punchLineNameNotLongEnoughTitle = "Punch-Line Name Too Short"
    static let punchLineNameNotLongEnoughMessage = "Custom Punch-Line names must contain a minimum of five characters."
    static let usernameUnavailableTitle = "Username Unavailable"
    static let usernameUnavailableMessage = "Please enter a different username and try again."
}

struct CellIdentifiers {
    static let jokeHistoryCell = "JokeHistoryCell"
    static let newPunchLineCell = "NewPunchLineCell"
    static let proTipCell = "ProTipCell"
    static let punchLineCell = "PunchLineCell"
    static let survivingJokeCell = "SurvivingJokeCell"
    static let toggleSettingCell = "ToggleSettingCell"
    static let userCell = "UserCell"
}

struct FlagActionTitles {
    static let cancel = "Cancel"
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
    static let showJokeDetailViewController = "ShowJokeDetailViewController"
    static let showUsernameViewController = "ShowUsernameViewController"
}

struct StoryboardNames {
    static let getStarted = "GetStarted"
    static let main = "Main"
    static let nothingToDo = "NothingToDo"
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
    static let joinedPunchLines = "Punch-Lines You've Joined"
    static let ownedPunchLines = "Punch-Lines You Own"
    static let publicPunchLines = "Public Punch-Lines"
    static let whatMadeTheCut = "What Made The Cut?"
}
