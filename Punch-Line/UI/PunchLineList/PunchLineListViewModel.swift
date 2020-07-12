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

    let publicPunchLineLaunchers = AppSession.sharedInstance.loggedInUser?.publicPunchLineLaunchers ?? List<PunchLineLauncher>()
    let customPunchLineLaunchers = AppSession.sharedInstance.loggedInUser?.customPunchLineLaunchers ?? List<PunchLineLauncher>()

}
