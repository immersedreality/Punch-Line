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
    let cloudKitID: CKRecord.ID
    let username: String
    let lastSignInDate: Date
    let todaysTaskCount: Int
    let shouldSeeOffensiveContent: Bool
}

struct UserInfoRecordKeys {
    static let type = "UserInfo"
    static let username = "username"
    static let lastSignInDate = "lastSignInDate"
    static let todaysTaskCount = "todaysTaskCount"
    static let shouldSeeOffensiveContent = "shouldSeeOffensiveContent"
}
