//
//  ProfileToggleSettingTableViewCell.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class ProfileToggleSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!

    func configure(with title: String) {
        settingTitleLabel.text = title
        contentBackgroundView.layer.borderWidth = 1.0
        contentBackgroundView.layer.borderColor = UIColor.punchlinePink.withAlphaComponent(0.1).cgColor
    }

}
