//
//  PunchLineEditor+CNContactPickerDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 11/3/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import UIKit
import ContactsUI

extension PunchLineEditorViewController: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        Task {
            await viewModel.matchContactEmailsToPunchLineUsers(contacts: contacts)
            userTableView.reloadData()
            if contacts.count > viewModel.matchedPunchLineUserIdentities.count {
                presentOkayAlertWith(title: AlertConstants.noAccountForContactTitle, message: AlertConstants.noAccountForContactMessage)
            }
        }
    }

}
