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
    @IBOutlet weak var setupTextView: UITextView!
    @IBOutlet weak var reminderLabel: UILabel!

    var activityContainerViewController: ActivityContainerViewController? {
        return parent as? ActivityContainerViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStartAJokeLabel()
        configureTextView()
        configureReminderLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTextView.becomeFirstResponder()
    }

    private func configureStartAJokeLabel() {
        switch AppSessionManager.userInfo?.todaysTaskCount {
        case 0:
            startAJokeLabel.text = ActivityFeedMessages.setupStartFirst
        case 1:
            startAJokeLabel.text = ActivityFeedMessages.setupStartSecond
        case 2:
            startAJokeLabel.text = ActivityFeedMessages.setupStartThird
        default:
            startAJokeLabel.text = ActivityFeedMessages.setupStartBeyond
        }
    }

    private func configureTextView() {
        setupTextView.delegate = self
    }

    private func configureReminderLabel() {
        reminderLabel.alpha = 0.0
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        guard setupTextView.text.removingSpaces().count >= 10 else {
            animateReminderLabel(with: ActivityFeedMessages.setupLength)
            return
        }

        guard setupTextView.text.last == "?" || setupTextView.text.last == "…" else {
            animateReminderLabel(with: ActivityFeedMessages.setupEnd)
            return
        }

        setupTextView.resignFirstResponder()
    }
    
    private func animateReminderLabel(with message: String) {
        reminderLabel.text = message
        UIView.animate(withDuration: 0.3, animations: {
            self.reminderLabel.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 5.3, animations: {
                self.reminderLabel.alpha = 0.0
            })
        }
    }

}
