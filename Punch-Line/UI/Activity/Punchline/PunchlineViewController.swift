//
//  PunchlineViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class PunchlineViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var finishThisJokeLabel: UILabel!
    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var punchlineTextView: UITextView!
    @IBOutlet weak var reminderLabel: UILabel!
    
    var activityContainerViewController: ActivityContainerViewController {
        return parent as! ActivityContainerViewController
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSetup()
        configureTextView()
        configureReminderLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        punchlineTextView.becomeFirstResponder()
    }

    // MARK: Config
    private func configureSetup() {
        setupLabel.text = activityContainerViewController.viewModel.getCurrentSetup()?.text
    }

    private func configureTextView() {
        punchlineTextView.delegate = self
    }

    private func configureReminderLabel() {
        reminderLabel.alpha = 0.0
    }
    
    // MARK: Actions
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard punchlineTextView.text.removingSpaces().count >= 2 else {
            animateReminderLabel(with: ActivityFeedMessages.punchlineLength)
            return
        }

        Task {
            await activityContainerViewController.viewModel.addJokeToPunchLine(text: punchlineTextView.text)
            performNavigation()
        }
    }

    @IBAction func flagButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let flagAsOffensiveAction = UIAlertAction(title: FlagActionTitles.flagSetupAsOffensive, style: .default) { _ in
            Task {
                await self.activityContainerViewController.viewModel.flagSetup(as: .offensive)
                self.performNavigation()
            }
        }
        let flagAsUnfunnyAction = UIAlertAction(title: FlagActionTitles.flagSetupAsUnfunny, style: .default) { _ in
            Task {
                await self.activityContainerViewController.viewModel.flagSetup(as: .unfunny)
                self.performNavigation()
            }
        }
        let cancelAction = UIAlertAction(title: FlagActionTitles.cancel, style: .cancel)

        alertController.addAction(flagAsOffensiveAction)
        alertController.addAction(flagAsUnfunnyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: Methods
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

    private func performNavigation() {
        punchlineTextView.resignFirstResponder()
        AppSessionManager.incrementTodaysTaskCount(for: activityContainerViewController.viewModel.getPunchlineStringIdentifier())
        activityContainerViewController.navigateToNextActivityFeedViewController()
    }

}
