//
//  JokeLookup+UITextFieldDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 1/5/23.
//  Copyright © 2023 Bozo Design Labs. All rights reserved.
//

import UIKit

extension JokeLookupViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        configureGestureRecognizer()

        if textField == selectPunchLineTextField {
            selectDateTextField.resignFirstResponder()
        } else if textField == selectDateTextField {
            selectPunchLineTextField.resignFirstResponder()
        }
    }

}
