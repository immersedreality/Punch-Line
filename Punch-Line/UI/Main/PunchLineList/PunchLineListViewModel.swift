//
//  PunchLineListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class PunchLineListViewModel {

    let publicPunchLineLaunchers = Array(AppSession.sharedInstance.loggedInUser?.publicPunchLineLaunchers ?? List<PunchLineLauncher>()).sorted {
        $0.sortValue < $1.sortValue
    }
    
    let customPunchLineLaunchers = Array(AppSession.sharedInstance.loggedInUser?.customPunchLineLaunchers ?? List<PunchLineLauncher>()).sorted {
        $0.name < $1.name
    }

    var selectedPunchLineLauncher: PunchLineLauncher?

    func generatePunchLineToLaunch() -> PunchLine? {
        guard let launcher = selectedPunchLineLauncher else { return nil }

        switch launcher.getType() {
        case .publicLauncher:
            guard let punchLineToLaunch = RealmAccessManager.getObject(
                of: PublicPunchLine.self,
                with: launcher.id,
                fromRealmAt: launcher.realmPath) else { return nil }
            return punchLineToLaunch
        case .customLauncher:
            guard let punchLineToLaunch = RealmAccessManager.getObject(
                of: CustomPunchLine.self,
                with: launcher.id,
                fromRealmAt: launcher.realmPath) else { return nil }
            return punchLineToLaunch
        }

    }

}
