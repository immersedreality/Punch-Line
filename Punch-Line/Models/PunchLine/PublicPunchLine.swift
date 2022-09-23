//
//  PublicPunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct PublicPunchLine: PunchLine {
    let cloudKitID: CKRecord.ID
    let owningLauncher: CKRecord.Reference
    let displayName: String
}

struct PublicPunchLineRecordKeys {
    static let type = "PublicPunchLine"
    static let owningLauncher = "owningLauncher"
    static let displayName = "displayName"
}
