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
    let cloudKitID: CKRecord.ID
    let owningPunchLine: CKRecord.Reference
    let text: String
    let author: String
    let isUnfunnyCount: Int
    let isOffensiveCount: Int
}

struct SetupRecordKeys {
    static let type = "Setup"
    static let owningPunchLine = "owningPunchLine"
    static let text = "text"
    static let author = "author"
    static let isUnfunnyCount = "isUnfunnyCount"
    static let isOffensiveCount = "isOffensiveCount"
}
