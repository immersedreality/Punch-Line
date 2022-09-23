//
//  Setup.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct Setup {
    let owningPunchLine: CKRecord.Reference
    let text: String
    let author: String
}

struct SetupRecordKeys {
    static let type = "Setup"
}
