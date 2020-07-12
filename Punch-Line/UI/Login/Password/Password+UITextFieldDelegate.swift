//
//  Password+UITextFieldDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension PasswordViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location > 24 {
            return false
        } else {
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let password = passwordTextField.text else { return false }

        guard password.count > 5 else {
            errorMessageLabel.text = UserAuthorizationConstants.passwordIsTooShort
            return false
        }

        textField.resignFirstResponder()
        activityIndicatorView.fadeInAndBeginAnimating()

        userAuthorizationManager.password = password
        userAuthorizationManager.initiateUserLogin { [weak self] (loginWasSuccessful, errorMessage) in
            DispatchQueue.main.async {
                self?.activityIndicatorView.fadeOutAndStopAnimating()
                if loginWasSuccessful {
                    self?.performSegue(withIdentifier: SegueIdentifiers.presentMainTabBarController, sender: self)
                } else {
                    self?.errorMessageLabel.text = errorMessage
                    textField.becomeFirstResponder()
                }
            }
        }

        return true
    }

}
