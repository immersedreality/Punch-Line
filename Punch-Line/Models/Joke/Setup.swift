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

    let id: String
    let dateCreated: Date = Date()

    let text: String
    let authorID: String

    let isOffensiveCount: Int
    let isUnfunnyCount: Int
    
}

enum SetupRecordKeys: String {
    case type = "Setup"
}

extension Setup {
    var record: CKRecord {
        let record = CKRecord(recordType: SetupRecordKeys.type.rawValue)
        return record
    }
}
