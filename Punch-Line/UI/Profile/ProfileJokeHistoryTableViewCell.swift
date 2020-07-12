//
//  ProfileJokeHistoryTableViewCell.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class ProfileJokeHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    func configure(with title: String) {
        titleLabel.text = title
        contentBackgroundView.layer.borderWidth = 1.0
        contentBackgroundView.layer.borderColor = UIColor.punchlinePink.withAlphaComponent(0.1).cgColor
    }

}
