//
//  PunchLineActivityViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import Foundation
import SwiftUI

class PunchLineActivityViewModel {

    let punchLineID: String
    private var activity: PunchLineActivity

    var currentSetup: String?
    var currentJoke: Joke?

    init(punchLineID: String, activity: PunchLineActivity) {
        self.punchLineID = punchLineID
        self.activity = activity
    }

    func setNextActivity() {
        switch activity {
        case .setup:
            self.activity = .punchline
            currentSetup = TestDataManager.getRandomSetup()
            currentJoke = nil
        case .punchline:
            self.activity = .vote
            currentJoke = TestDataManager.getRandomJoke()
            currentSetup = nil
        case .vote:
            self.activity = .setup
            currentSetup = nil
            currentJoke = nil
        }
    }

    func getCurrentActivity() -> PunchLineActivity {
        return activity
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
        }

    }

}

enum PunchLineActivity {
    case setup, punchline, vote
}
