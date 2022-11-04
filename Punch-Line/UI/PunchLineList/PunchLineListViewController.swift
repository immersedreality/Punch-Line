//
//  PunchLineListViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class PunchLineListViewController: UIViewController {

    @IBOutlet weak var punchLineListTableView: UITableView!

    var viewModel = PunchLineListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configurePunchLineListTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CoreLocationManager.handleLocationServicesAuthorizationStatus(for: self)
    }

    private func configureNavigationBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Icon-NavigationTitle"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .punchlinePink
        self.navigationItem.titleView = imageView
    }

    private func configurePunchLineListTableView() {
        punchLineListTableView.dataSource = self
        punchLineListTableView.delegate = self
    }

    private func reloadTableView() {
        viewModel = PunchLineListViewModel()
        Task {
            await viewModel.fetchCustomPunchlineLaunchers()
            punchLineListTableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case SegueIdentifiers.presentActivityFeedViewController:
            guard let activityContainerNavigationController = segue.destination as? UINavigationController else { return }
            guard let activityContainerViewController =  activityContainerNavigationController.topViewController as? ActivityContainerViewController else { return }
            guard let punchlineToLaunch = viewModel.punchlineToLaunch else { return }
            let activityFeedViewModel = ActivityFeedViewModel(punchLine: punchlineToLaunch)
            if let setupToLaunchWith = viewModel.setUpToLaunchWith {
                activityFeedViewModel.setCurrent(setup: setupToLaunchWith)
            } else if let jokeToLaunchWith = viewModel.jokeToLaunchWith {
                activityFeedViewModel.setCurrent(joke: jokeToLaunchWith)
            }
            activityContainerViewController.viewModel = activityFeedViewModel
        case SegueIdentifiers.presentPunchLineEditorViewController:
            return
        default:
            return
        }

    }
    
}
