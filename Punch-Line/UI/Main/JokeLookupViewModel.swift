//
//  JokeLookupViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 1/12/23.
//  Copyright © 2023 Bozo Design Labs. All rights reserved.
//

import Foundation

class JokeLookupViewModel {

    var currentPunchLineLaunchers: [PunchLineLauncher] = []
    var selectedPunchLineLauncherIndex: Int = 0
    var selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    var currentCompletedPunchLine: CompletedPunchLine?

    var currentPunchLineName: String {
        return currentPunchLineLaunchers[selectedPunchLineLauncherIndex].displayName
    }
    
    func configureCurrentPunchLineLaunchers() async {
        currentPunchLineLaunchers.append(contentsOf: AppSessionManager.currentPublicPunchLineLaunchers)
        let ownedCustomPunchlineLaunchers = await CloudKitManager.getOwnedCustomPunchLineLaunchers()
        currentPunchLineLaunchers.append(contentsOf: ownedCustomPunchlineLaunchers)
        let joinedCustomPunchlineLaunchers = await CloudKitManager.getJoinedCustomPunchLineLaunchers()
        currentPunchLineLaunchers.append(contentsOf: joinedCustomPunchlineLaunchers)
    }

    func fetchCompletedPunchLineForCurrentLauncherAndDate() async {
        currentCompletedPunchLine = await CloudKitManager.getCompletedPunchLine(
            for: currentPunchLineLaunchers[selectedPunchLineLauncherIndex],
            date: selectedDate
        )
    }

}
