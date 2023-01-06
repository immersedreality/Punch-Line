//
//  JokeListViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class JokeListViewController: UIViewController {

    @IBOutlet weak var jokeListTableView: UITableView!
    @IBOutlet weak var noJokesView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        jokeListTableView.delegate = self
        jokeListTableView.dataSource = self
        jokeListTableView.sectionHeaderTopPadding = 0
        jokeListTableView.rowHeight = UITableView.automaticDimension
        jokeListTableView.estimatedRowHeight = 100.0
    }
    
}
