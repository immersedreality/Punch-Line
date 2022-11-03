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
    let todaysPunchlines: [String]
    let todaysTaskCounts: [Int]
    let shouldSeeOffensiveContent: Bool
}

struct UserInfoRecordKeys {
    static let type = "UserInfo"
    static let username = "username"
    static let lastSignInDate = "lastSignInDate"
    static let todaysPunchlines = "todaysPunchlines"
    static let todaysTaskCounts = "todaysTaskCounts"
    static let shouldSeeOffensiveContent = "shouldSeeOffensiveContent"
}
