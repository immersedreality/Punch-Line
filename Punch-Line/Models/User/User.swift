//
//  User.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct User {
    let username: String
    let shouldSeeOffensiveContent: Bool
}

extension User {
    var record: CKRecord {
        let record = CKRecord(recordType: "User")
        record["username"] = username as CKRecordValue
        record["shouldSeeOffensiveContent"] = shouldSeeOffensiveContent as CKRecordValue
        return record
    }
}
