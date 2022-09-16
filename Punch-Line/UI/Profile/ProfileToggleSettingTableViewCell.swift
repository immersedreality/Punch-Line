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

    var switchType: ProfileSwitchType = .offensiveContent

    weak var delegate: ProfileCellActionDelegate?

    func configure(with title: String, switchType: ProfileSwitchType) {
        settingTitleLabel.text = title
        contentBackgroundView.layer.borderWidth = 1.0
        contentBackgroundView.layer.borderColor = UIColor.punchlinePink.withAlphaComponent(0.1).cgColor
        self.switchType = switchType

        switch switchType {
        case .offensiveContent:
            settingSwitch.isOn = AppSessionManager.userInfo?.shouldSeeOffensiveContent ?? false
        }

    }

    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchValueChanged(for: switchType)
    }

}
