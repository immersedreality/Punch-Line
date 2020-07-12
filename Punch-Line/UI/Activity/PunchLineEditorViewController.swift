//
//  PunchLineEditorViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class PunchLineEditorViewController: UIViewController {
    
    @IBOutlet weak var punchLineNameTextField: UITextField!
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var createUpdateButton: UIButton!

    var mode: PunchLineEditorMode = .create

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTextFieldStyle()
    }

    private func configureTextFieldStyle() {
        punchLineNameTextField.addBottomBorderOf(color: .punchlinePink)
    }
    
    @IBAction func createUpdateButtonTapped(_ sender: Any) {
    }

}

enum PunchLineEditorMode {
    case create, edit
}
