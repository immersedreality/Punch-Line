//
//  PunchLineListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

class PunchLineListViewModel {

    var publicPunchLineLaunchers: [PunchLineLauncher] {
        get {
            return AppSessionManager.currentPublicPunchlineLaunchers
        }
    }
    let customPunchLineLaunchers: [PunchLineLauncher] = []

    var selectedPunchLineLauncher: PunchLineLauncher?
    var punchlineToLaunch: PunchLine?
    
    func generatePublicPunchLineToLaunch() async {
        guard let launcher = selectedPunchLineLauncher else { return }

        let allPunchLinesForLauncher = await CloudKitManager.getPunchLines(for: launcher)

        guard !allPunchLinesForLauncher.isEmpty else {
            let newPunchLine = await CloudKitManager.createNewPublicPunchLine(for: launcher)
            punchlineToLaunch = newPunchLine
            return
        }

        punchlineToLaunch = allPunchLinesForLauncher.first { punchLine in
            CloudKitManager.getItemCount(for: punchLine) <= 750
        } as? PublicPunchLine
    }

    func generateCustomPunchLineToLaunch() -> CustomPunchLine? {
        return nil
    }

}
