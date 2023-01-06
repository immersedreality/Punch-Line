//
//  PunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct PunchLine {
    let cloudKitID: CKRecord.ID
    let owningLauncher: CKRecord.Reference
    let displayName: String
}

struct PunchLineRecordKeys {
    static let type = "PunchLine"
    static let owningLauncher = "owningLauncher"
    static let displayName = "displayName"
}
