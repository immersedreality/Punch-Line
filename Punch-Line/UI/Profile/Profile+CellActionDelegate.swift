//
//  Profile+CellActionDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 9/16/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import UIKit

extension ProfileViewController: ProfileCellActionDelegate {

    func switchValueChanged(for switchType: ProfileSwitchType) {
        switch switchType {
        case .offensiveContent:
            AppSessionManager.toggleOffensiveContentFilter()
        }
    }

}
