//
//  JokeListViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class JokeListViewController: UIViewController {

    @IBAction func profileButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers.presentProfileViewController, sender: self)
    }
    
}

enum JokeListMode {
    case topTen
    case usersSurviving
}
