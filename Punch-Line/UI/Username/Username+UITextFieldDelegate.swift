//
//  Username+UITextFieldDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension UsernameViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location > 24 {
            return false
        } else {
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let username = usernameTextField.text else { return false }
        guard username.count > 0 else { return false }
        
        userAuthorizationManager.username = username
        self.performSegue(withIdentifier: SegueIdentifiers.showPasswordViewController, sender: self)
        return true
    }

}
