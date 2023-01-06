//
//  CompletedPunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 1/5/23.
//  Copyright © 2023 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct CompletedPunchLine {
    let cloudKitID: CKRecord.ID
    let displayName: String
    let scope: PunchLineScope
    let dateCompleted: Date

    let topTenSetUps: [String]
    let topTenSetUpAuthors: [String]
    let topTenPunchlines: [String]
    let topTenPunchlineAuthors: [String]
}

struct CompletedPunchLineRecordKeys {
    static let type = "PublicPunchLine"
    static let displayName = "displayName"
    static let scope = "scope"
    static let dateCompleted = "dateCompleted"
    static let topTenSetUps = "topTenSetUps"
    static let topTenSetUpAuthors = "topTenSetUpAuthors"
    static let topTenPunchlines = "topTenPunchlines"
    static let topTenPunchlineAuthors = "topTenPunchlineAuthors"
}
