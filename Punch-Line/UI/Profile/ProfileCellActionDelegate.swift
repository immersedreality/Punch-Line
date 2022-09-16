//
//  ProfileCellActionDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 9/16/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import UIKit

protocol ProfileCellActionDelegate: AnyObject {
    func switchValueChanged(for switchType: ProfileSwitchType)
}

enum ProfileSwitchType {
    case offensiveContent
}
