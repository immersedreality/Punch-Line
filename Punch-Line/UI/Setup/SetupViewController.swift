//
//  SetupViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var startAJokeLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackgroundColor()
    }

    private func configureBackgroundColor() {
        view.backgroundColor = StyleManager.generateRandomBackgroundColor()
    }

    var activityContainerViewController: ActivityContainerViewController? {
        return parent as? ActivityContainerViewController
    }
    
}
