//
//  PunchLineActivityViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import Foundation
import SwiftUI

class PunchLineActivityViewModel {

    let punchLine: PunchLine
    private(set) var activity: PunchLineActivity
    private(set) var activityDisplayText: String
    var currentSetup: String?
    var currentJoke: Joke?

    init(punchLine: PunchLine, activity: PunchLineActivity, activityDisplayText: String) {
        AppSessionManager.resetTaskCountsIfNecessary()
        self.punchLine = punchLine
        self.activity = activity
        self.activityDisplayText = activityDisplayText
    }

    func setNextActivity() {

        AppSessionManager.incrementTodaysTaskCount(for: punchLine.id)
        
        guard let todaysTaskCount = AppSessionManager.userInfo?.todaysTaskCounts[punchLine.id] else {
            activity = .nothingToDo
            activityDisplayText = ""
            currentSetup = nil
            currentJoke = nil
            return
        }

        switch todaysTaskCount {
        case 0:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupFirst
            currentSetup = nil
            currentJoke = nil
        case 1:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupSecond
            currentSetup = nil
            currentJoke = nil
        case 2:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupThird
            currentSetup = nil
            currentJoke = nil
        case 3, 5, 8, 12, 17, 23, 30, 38, 47, 57:
            activity = .punchline
            activityDisplayText = ActivityFeedMessages.punchline
            currentSetup = TestDataManager.getRandomSetup()
            currentJoke = nil
        default:
            activity = .vote
            activityDisplayText = ActivityFeedMessages.vote
            currentJoke = TestDataManager.getRandomJoke()
            currentSetup = nil
        }

    }

    func isValid(textEntry: String) -> Bool {

        switch activity {
        case .setup:
            guard textEntry.removingSpaces().count >= 10 else {
                return false
            }

            guard textEntry.last == "?" || textEntry.last == "…" else {
                return false
            }

            return true
        case .punchline:
            guard textEntry.removingSpaces().count >= 2 else {
                return false
            }
            
            return true
        case .vote:
            return true
        case .nothingToDo:
            return true
        }

    }

}

enum PunchLineActivity {
    case setup, punchline, vote, nothingToDo
}
