//
//  ActivityFeedManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

final class ActivityFeedManager {

    class func generateActivityFeedViewController() -> ActivityFeedViewController {

        guard let todaysTaskCount = AppSessionManager.userInfo?.todaysTaskCount else {
            return instantiateVoteViewController()
        }

        switch todaysTaskCount {
        case 0...2:
            return instantiateSetupViewController()
        case 3, 5, 8, 12, 17, 23, 30, 38, 47, 57:
            return instantiatePunchlineViewController()
        default:
            return instantiateVoteViewController()
        }

    }


    private class func instantiateSetupViewController() -> SetupViewController {
        let storyboard = UIStoryboard(name: StoryboardNames.setup, bundle: nil)
        if let setupViewController = storyboard.instantiateInitialViewController() as? SetupViewController {
            return setupViewController
        } else {
            return SetupViewController()
        }
    }

    private class func instantiatePunchlineViewController() -> PunchlineViewController {
        let storyboard = UIStoryboard(name: StoryboardNames.punchline, bundle: nil)
        if let punchlineViewController = storyboard.instantiateInitialViewController() as? PunchlineViewController {
            return punchlineViewController
        } else {
            return PunchlineViewController()
        }
    }

    private class func instantiateVoteViewController() -> VoteViewController {
        let storyboard = UIStoryboard(name: StoryboardNames.vote, bundle: nil)
        if let voteViewController = storyboard.instantiateInitialViewController() as? VoteViewController {
            return voteViewController
        } else {
            return VoteViewController()
        }
    }
    
}
