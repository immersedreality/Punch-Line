//
//  ActivityContainerViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class ActivityContainerViewController: UIViewController {
    
    @IBOutlet weak var activityContainerView: UIView!

    var viewModel: ActivityFeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChildViewController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeEarlierActivityFeedViewController()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.clearFetchedValues()
    }

    private func configureChildViewController() {
        let punchlineID = viewModel.getPunchlineStringIdentifier()
        let nextActivityFeedViewController = ActivityFeedManager.generateActivityFeedViewController(for: punchlineID)

        if (nextActivityFeedViewController is PunchlineViewController && viewModel.getCurrentSetup() == nil) ||
            (nextActivityFeedViewController is VoteViewController && viewModel.getCurrentJoke() == nil) {
            let nothingToDoViewController = ActivityFeedManager.instantiateNothingToDoViewController()
            self.addChild(nothingToDoViewController)
            self.view.addSubview(nothingToDoViewController.view)
            nextActivityFeedViewController.didMove(toParent: self)
            return
        }

        self.addChild(nextActivityFeedViewController)
        self.view.addSubview(nextActivityFeedViewController.view)
        nextActivityFeedViewController.didMove(toParent: self)
    }

    private func removeEarlierActivityFeedViewController() {
        guard let navigationController = navigationController else { return }
        if navigationController.viewControllers.count > 1 {
            navigationController.viewControllers.removeFirst()
        }
    }

    func navigateToNextActivityFeedViewController() {
        guard let punchlineIndex = AppSessionManager.userInfo?.todaysPunchlines.firstIndex(of: viewModel.getPunchlineStringIdentifier()) else {
            return
        }

        guard let todaysTaskCount = AppSessionManager.userInfo?.todaysTaskCounts[punchlineIndex] else {
            return
        }

        viewModel.clearCurrentValues()

        Task {
            switch todaysTaskCount {
            case 1...2:
                break
            case 3, 5, 8, 12, 17, 23, 30, 38, 47, 57:
                await viewModel.getARandomSetup()
            default:
                await viewModel.getARandomJoke()
            }

            performSegue(withIdentifier: SegueIdentifiers.showActivityContainerViewController, sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case SegueIdentifiers.showActivityContainerViewController:
            guard let activityContainerViewController = segue.destination as? ActivityContainerViewController else { return }
            activityContainerViewController.viewModel = self.viewModel
        default:
            return
        }

    }

}
