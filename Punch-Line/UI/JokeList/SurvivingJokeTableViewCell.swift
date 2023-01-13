//
//  SurvivingJokeTableViewCell.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 1/12/23.
//  Copyright © 2023 Bozo Design Labs. All rights reserved.
//

import UIKit

class SurvivingJokeTableViewCell: UITableViewCell {

    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var punchlineLabel: UILabel!

    var survivingJoke: SurvivingJoke! {
        didSet {
            setupLabel.text = survivingJoke.setup
            punchlineLabel.text = survivingJoke.punchline
        }
    }

}
