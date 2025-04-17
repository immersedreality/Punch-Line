//
//  PunchLineLaunchersViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import Foundation

class PunchLineLaunchersViewModel {

    var selectedPunchLine: PunchLine?

    func getInitialPunchLineActivity() -> PunchLineActivity {

        guard let selectedPunchLineID = selectedPunchLine?.id else {
            return .somethingWentWrong
        }

        if let todaysTaskCount = AppSessionManager.userInfo?.todaysTaskCounts[selectedPunchLineID] {
            switch todaysTaskCount {
            case 0, 1, 2:
                return .setup
            case 3, 5, 8, 12, 17, 23, 30, 38, 47, 57:
                return .punchline
            default:
                return .vote
            }
        } else {
            AppSessionManager.createTaskCountKey(for: selectedPunchLineID)
            return .setup
        }

    }

    func getInitialPunchLineActivityDisplayText() -> String {

        guard let selectedPunchLineID = selectedPunchLine?.id else {
            return ActivityFeedMessages.weDoneGoofed
        }

        if let todaysTaskCount = AppSessionManager.userInfo?.todaysTaskCounts[selectedPunchLineID] {
            switch todaysTaskCount {
            case 0:
                return ActivityFeedMessages.setupFirst
            case 1:
                return ActivityFeedMessages.setupSecond
            case 2:
                return ActivityFeedMessages.setupThird
            case 3, 5, 8, 12, 17, 23, 30, 38, 47, 57:
                return ActivityFeedMessages.punchline
            default:
                return ActivityFeedMessages.vote
            }
        } else {
            return ActivityFeedMessages.weDoneGoofed
        }

    }


}
