//
//  PunchLineViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import Foundation
import SwiftUI

class PunchLineViewModel {

    let punchLineID: String
    let activity: PunchLineActivity

    init(punchLineID: String, activity: PunchLineActivity) {
        self.punchLineID = punchLineID
        self.activity = activity
    }

    func getNextActivity() -> PunchLineActivity {
        switch activity {
        case .setup:
            return .punchline
        case .punchline:
            return .vote
        case .vote:
            return .setup
        }
    }

    func getCurrentActivity() -> PunchLineActivity {
        return activity
    }

}

enum PunchLineActivity {
    case setup, punchline, vote
}
