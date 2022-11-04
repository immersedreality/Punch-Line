//
//  NothingToDoViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 11/3/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import UIKit

class NothingToDoViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackgroundColor()
    }
    
}

extension NothingToDoViewController: ActivityFeedViewController {

}
