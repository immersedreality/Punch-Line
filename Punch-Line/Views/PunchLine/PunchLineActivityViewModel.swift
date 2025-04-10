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

    init(punchLineID: String, activity: PunchLineActivity) {
        self.punchLineID = punchLineID
        self.activity = activity
    }

    func setNextActivity() {
        switch activity {
        case .setup:
            self.activity = .punchline
        case .punchline:
            self.activity = .vote
        case .vote:
            self.activity = .setup
        }
    }

    func getCurrentActivity() -> PunchLineActivity {
        return activity
    }

}

enum PunchLineActivity {
    case setup, punchline, vote
}
