//
//  MainTabBarController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    let punchLineSyncManager = PunchLineSyncManager()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CoreLocationManager.handleLocationServicesAuthorizationStatus(for: punchLineSyncManager)
    }

}
