//
//  ActiviteFeedViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

protocol ActivityFeedViewController: UIViewController {
    func configureBackgroundColor()
}

extension ActivityFeedViewController {

    func configureBackgroundColor() {
        view.backgroundColor = StyleManager.generateRandomBackgroundColor()
    }

}
