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

    private func configureChildViewController() {
        let punchlineID = viewModel.punchLine.cloudKitID.recordName
        let nextActivityFeedViewController = ActivityFeedManager.generateActivityFeedViewController(for: punchlineID)
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
        performSegue(withIdentifier: SegueIdentifiers.showActivityContainerViewController, sender: self)
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
