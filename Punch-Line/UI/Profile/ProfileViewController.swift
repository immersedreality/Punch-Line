//
//  SettingsViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfileTableView()
        configureBackgroundColor()
    }
    
    private func configureProfileTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }

    private func configureBackgroundColor() {
        view.backgroundColor = StyleManager.generateRandomBackgroundColor()
    }

    @IBAction func deleteAppDataButtonPressed(_ sender: Any) {
        #warning("TODO: Implement iCloud user data deletion")
    }

}
