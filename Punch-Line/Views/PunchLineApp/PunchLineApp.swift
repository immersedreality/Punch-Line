//
//  PunchLineApp.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/18/25.
//

import SwiftUI

@main
struct PunchLineApp: App {

    let viewModel = PunchLineAppViewModel()

    init() {
        viewModel.validateUserInfo()
        TestDataManager.initializeTestJokeHistoryEntryGroups()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
