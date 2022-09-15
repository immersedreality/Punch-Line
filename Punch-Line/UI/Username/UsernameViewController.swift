//
//  LogInViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class UsernameViewController: UIViewController {

    @IBOutlet weak var enterUsernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTextFieldStyle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        usernameTextField.resignFirstResponder()
    }

    private func configureTextField() {
        usernameTextField.delegate = self
    }

    private func configureNavigationController() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureTextFieldStyle() {
        usernameTextField.addBottomBorderOf(color: .punchlinePink)
    }

}
