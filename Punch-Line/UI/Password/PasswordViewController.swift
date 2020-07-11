//
//  PasswordViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var enterPasswordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!

    let activityIndicatorView = UIActivityIndicatorView()

    var userAuthorizationManager: UserAuthorizationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureActivityIndicatorView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
        configureEnterPasswordLabel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTextFieldStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        passwordTextField.resignFirstResponder()
    }

    private func configureTextField() {
        passwordTextField.delegate = self

        switch userAuthorizationManager.authorizationMode {
        case .newUser:
            passwordTextField.textContentType = .newPassword
        case .returningUser:
            passwordTextField.textContentType = .password
        }

    }

    private func configureActivityIndicatorView() {
        activityIndicatorView.alpha = 0.0
        activityIndicatorView.style = .large
        activityIndicatorView.color = .punchlinePink
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
    }

    private func configureNavigationController() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureEnterPasswordLabel() {
        switch userAuthorizationManager.authorizationMode {
        case .newUser:
            enterPasswordLabel.text = UserAuthorizationConstants.enterAPassword
        case .returningUser:
            enterPasswordLabel.text = UserAuthorizationConstants.enterYourPassword
        }
    }

    private func configureTextFieldStyle() {
        passwordTextField.addBottomBorderOf(color: .punchlinePink)
    }
    
}
