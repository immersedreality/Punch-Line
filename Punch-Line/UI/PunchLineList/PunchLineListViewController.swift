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

    override func viewDidLoad() {
        configurePunchLineListTableView()
    }

    private func configurePunchLineListTableView() {
        punchLineListTableView.dataSource = self
        punchLineListTableView.delegate = self
    }

}
