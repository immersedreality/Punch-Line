//
//  MainTabBarController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            if await CloudKitManager.requestUserDiscoverabilityPermission() == false {
                presentOkayAlertWith(title: AlertConstants.notCurrentlyDiscoverableTitle, message: AlertConstants.notCurrentlyDiscoverableMessage)
            }
        }
    }

}
