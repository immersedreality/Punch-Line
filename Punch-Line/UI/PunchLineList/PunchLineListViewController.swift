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

    let viewModel = PunchLineListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
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

    private func configurePunchLineListTableView() {
        punchLineListTableView.dataSource = self
        punchLineListTableView.delegate = self
    }

    private func reloadTableView() {
        punchLineListTableView.reloadData()
    }

    func reloadTableViewWithAnimation() {
        punchLineListTableView.reloadSections([0, 1], with: .fade)
    }

}
