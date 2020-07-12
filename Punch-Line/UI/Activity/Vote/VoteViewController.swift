//
//  VoteViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {

    @IBOutlet weak var isThisFunnyLabel: UILabel!
    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var punchlineLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackgroundColor()
    }
    
    @IBAction func haButtonTapped(_ sender: Any) {
    }
    
    @IBAction func mehButtonTapped(_ sender: Any) {
    }

    @IBAction func ughButtonTapped(_ sender: Any) {
    }

    @IBAction func flagButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let flagAsOffensiveAction = UIAlertAction(title: FlagActionTitles.flagJokeAsOffensive, style: .default, handler: nil)
        let flagAsTooFunnyAction = UIAlertAction(title: FlagActionTitles.flagJokeAsTooFunny, style: .default, handler: nil)
        alertController.addAction(flagAsOffensiveAction)
        alertController.addAction(flagAsTooFunnyAction)
        present(alertController, animated: true, completion: nil)
    }

}
