//
//  UserInfo.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct UserInfo {
    let username: String
    let shouldSeeOffensiveContent: Bool
}

struct UserInfoRecordKeys {
    static let type = "UserInfo"
    static let username = "username"
    static let shouldSeeOffensiveContent = "shouldSeeOffensiveContent"
}

extension UserInfo {
    var record: CKRecord {
        let record = CKRecord(recordType: UserInfoRecordKeys.type)
        record[UserInfoRecordKeys.username] = username as CKRecordValue
        record[UserInfoRecordKeys.shouldSeeOffensiveContent] = shouldSeeOffensiveContent as CKRecordValue
        return record
    }
}
