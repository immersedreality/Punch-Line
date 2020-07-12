//
//  PunchlineViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class PunchlineViewController: UIViewController {

    @IBOutlet weak var finishThisJokeLabel: UILabel!
    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var punchlineTextView: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackgroundColor()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
    }

    @IBAction func flagButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let flagAsOffensiveAction = UIAlertAction(title: FlagActionTitles.flagSetupAsOffensive, style: .default, handler: nil)
        let flagAsUnfunnyAction = UIAlertAction(title: FlagActionTitles.flagSetupAsUnfunny, style: .default, handler: nil)
        alertController.addAction(flagAsOffensiveAction)
        alertController.addAction(flagAsUnfunnyAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
