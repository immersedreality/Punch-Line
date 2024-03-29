//
//  PunchLineEditorViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit
import ContactsUI

class PunchLineEditorViewController: UIViewController {
    
    @IBOutlet weak var punchLineNameTextField: UITextField!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var createUpdateButton: UIButton!

    var mode: PunchLineEditorMode = .create

    var viewModel = PunchLineEditorViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        punchLineNameTextField.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTextFieldStyle()
    }

    private func configureTextField() {
        punchLineNameTextField.delegate = self
    }

    private func configureTableView() {
        userTableView.delegate = self
        userTableView.dataSource = self
    }

    private func configureTextFieldStyle() {
        punchLineNameTextField.addBottomBorderOf(color: .punchlinePink)
    }
    
    @IBAction func openContactsButtonTapped(_ sender: Any) {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate = self
        present(contactPickerViewController, animated: true)
    }
    
    @IBAction func createUpdateButtonTapped(_ sender: Any) {
        guard let punchLineName = punchLineNameTextField.text, punchLineName.removingSpaces().count >= 5 else {
            presentOkayAlertWith(title: AlertConstants.punchLineNameNotLongEnoughTitle, message: AlertConstants.punchLineNameNotLongEnoughMessage)
            return
        }

        guard viewModel.matchedPunchLineUserIdentities.count > 0 else {
            presentOkayAlertWith(title: AlertConstants.punchLineNeedsFriendsTitle, message: AlertConstants.punchLineNeedsFriendsMessage)
            return
        }

        Task {
            await viewModel.createCustomPunchLineLauncher(with: punchLineName)
            self.dismiss(animated: true)
        }
    }
    
}

enum PunchLineEditorMode {
    case create, edit
}
