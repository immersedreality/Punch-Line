//
//  PunchLineEditor+TextFieldDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 11/3/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import UIKit

extension PunchLineEditorViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        openContactsButtonTapped(self)
        return true
    }

}
