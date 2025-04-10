//
//  PunchLineLaunchersViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import Foundation

class PunchLineLaunchersViewModel {

    var selectedPunchLineID: String?

    func getInitialPunchLineActivity() -> PunchLineActivity {
        return .setup
    }
    
}
