//
//  PunchLineAppViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/20/25.
//

import Foundation

class PunchLineAppViewModel {

    func validatePunchLineUserID() {
        if UserDefaults.standard.value(forKey: UserDefaultsKeys.punchLineUserID) == nil {
            setPunchLineUserID()
        }
    }

    private func setPunchLineUserID() {
        UserDefaults.standard.set(UUID().uuidString, forKey: UserDefaultsKeys.punchLineUserID)
    }

}
