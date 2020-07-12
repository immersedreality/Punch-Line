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
    
    let customPunchLineLaunchers = Array(AppSession.sharedInstance.loggedInUser?.customPunchLineLaunchers ?? List<PunchLineLauncher>())

}
