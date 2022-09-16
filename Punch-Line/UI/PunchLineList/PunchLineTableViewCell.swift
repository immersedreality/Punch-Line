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
    @IBOutlet weak var regionSizeLabel: UILabel!

    var punchLineLauncher: PunchLineLauncher! {
        didSet {
            configure()
        }
    }

    private func configure() {
        contentContainerView.backgroundColor = StyleManager.generateRandomBackgroundColor()
        punchLineTitleLabel.text = punchLineLauncher.displayName
        regionSizeLabel.text = punchLineLauncher.scope.displayName
    }
    
}
