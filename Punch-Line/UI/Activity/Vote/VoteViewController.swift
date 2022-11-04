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

    var activityContainerViewController: ActivityContainerViewController {
        return parent as! ActivityContainerViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureJoke()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackgroundColor()
    }

    private func configureJoke() {
        let joke = activityContainerViewController.viewModel.getCurrentJoke()
        setupLabel.text = joke?.setup
        punchlineLabel.text = joke?.punchline
    }
    
    @IBAction func haButtonTapped(_ sender: Any) {
        Task {
            await activityContainerViewController.viewModel.voteOnJoke(vote: .ha)
            performNavigation()
        }
    }
    
    @IBAction func mehButtonTapped(_ sender: Any) {
        Task {
            await activityContainerViewController.viewModel.voteOnJoke(vote: .meh)
            performNavigation()
        }
    }

    @IBAction func ughButtonTapped(_ sender: Any) {
        Task {
            await activityContainerViewController.viewModel.voteOnJoke(vote: .ugh)
            performNavigation()
        }
    }

    @IBAction func flagButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let flagAsOffensiveAction = UIAlertAction(title: FlagActionTitles.flagJokeAsOffensive, style: .default) { _ in
            Task {
                await self.activityContainerViewController.viewModel.flagJoke(as: .offensive)
                self.performNavigation()
            }
        }
        let flagAsTooFunnyAction = UIAlertAction(title: FlagActionTitles.flagJokeAsTooFunny, style: .default) { _ in
            Task {
                await self.activityContainerViewController.viewModel.flagJoke(as: .tooFunny)
                self.performNavigation()
            }
        }
        let cancelAction = UIAlertAction(title: FlagActionTitles.cancel, style: .cancel)

        alertController.addAction(flagAsOffensiveAction)
        alertController.addAction(flagAsTooFunnyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    private func performNavigation() {
        AppSessionManager.incrementTodaysTaskCount(for: activityContainerViewController.viewModel.getPunchlineStringIdentifier())
        activityContainerViewController.navigateToNextActivityFeedViewController()
    }
    
}
