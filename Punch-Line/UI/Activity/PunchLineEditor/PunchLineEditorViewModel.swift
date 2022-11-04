//
//  PunchLineEditorViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 11/3/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import Foundation
import Contacts
import CloudKit

class PunchLineEditorViewModel {

    var matchedPunchLineUserIdentities: [CKUserIdentity] = []

    func matchContactEmailsToPunchLineUsers(contacts: [CNContact]) async {
        for contact in contacts {
            for emailAddress in contact.emailAddresses {
                let emailAddressString = String(emailAddress.value)
                if let matchedIdentity = await CloudKitManager.getAccountIfItExistsFor(emailAddress: emailAddressString) {
                    matchedPunchLineUserIdentities.append(matchedIdentity)
                }
            }
        }
    }
    
}
