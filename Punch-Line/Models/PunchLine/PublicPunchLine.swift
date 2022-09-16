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
    let name: String
}

struct PublicPunchLineRecordKeys {
    static let type = "PublicPunchLine"
    static let name = "name"
}

extension PublicPunchLine {
    var record: CKRecord {
        let record = CKRecord(recordType: PublicPunchLineRecordKeys.type)
        record[PublicPunchLineRecordKeys.name] = name as CKRecordValue
        return record
    }
}
