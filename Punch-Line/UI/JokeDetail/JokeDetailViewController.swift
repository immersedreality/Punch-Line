//
//  JokeDetailViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class JokeDetailViewController: UIViewController {

    @IBOutlet weak var rememberThisOneLabel: UILabel!
    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var punchlineLabel: UILabel!
    @IBOutlet weak var setupAuthorValueLabel: UILabel!
    @IBOutlet weak var punchlineAuthorValueLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!

    var survivingJoke: SurvivingJoke!

    override func viewWillAppear(_ animated: Bool) {
        configureLabels()
    }

    private func configureLabels() {
        setupLabel.text = survivingJoke.setup
        punchlineLabel.text = survivingJoke.punchline
        setupAuthorValueLabel.text = survivingJoke.setupAuthor
        punchlineAuthorValueLabel.text = survivingJoke.punchlineAuthor
        dateValueLabel.text = survivingJoke.dateCreated.formatted(
            date: Date.FormatStyle.DateStyle.numeric,
            time: Date.FormatStyle.TimeStyle.omitted
        )
    }

    @IBAction func favoritesButtonTapped(_ sender: Any) {
    }
    
}
