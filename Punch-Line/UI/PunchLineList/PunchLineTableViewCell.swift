//
//  PunchLineTableViewCell.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class PunchLineTableViewCell: UITableViewCell {

    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var punchLineTitleLabel: UILabel!

    func configure() {
        contentContainerView.backgroundColor = StyleManager.generateRandomBackgroundColor()
    }

}
