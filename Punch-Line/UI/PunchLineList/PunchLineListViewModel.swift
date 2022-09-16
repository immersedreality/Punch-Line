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

    func generatePunchLineToLaunch() -> PunchLine? {
//        guard let launcher = selectedPunchLineLauncher else { return nil }
//        switch launcher.type {
//        #warning("TODO: Write logic to launch Punch-Lines")
//        case .publicLauncher:
//            return nil
//        case .customLauncher:
//            return nil
//        }

        return nil

    }

}
