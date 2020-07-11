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

    var userAuthorizationManager: UserAuthorizationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
        configureEnterUsernameLabel()
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

    private func configureEnterUsernameLabel() {
        switch userAuthorizationManager.authorizationMode {
        case .newUser:
            enterUsernameLabel.text = UserAuthorizationConstants.enterAUsername
        case .returningUser:
            enterUsernameLabel.text = UserAuthorizationConstants.enterYourUsername
        }
    }

    private func configureTextFieldStyle() {
        usernameTextField.addBottomBorder(of: ColorConstants.punchlinePink)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueIdentifiers.showPasswordViewController else { return }
        guard let passwordViewController = segue.destination as? PasswordViewController else { return }
        passwordViewController.userAuthorizationManager = userAuthorizationManager
    }

}
