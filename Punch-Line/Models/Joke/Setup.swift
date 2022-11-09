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
    let totalInteractionsCount: Int
    let isUnfunnyCount: Int
    let isOffensiveCount: Int

    var isUnfunny: Bool {
        guard totalInteractionsCount > 10 else { return false }
        return (Double(isUnfunnyCount) / Double(totalInteractionsCount)) > 0.25
    }

    var isOffensive: Bool {
        guard isOffensiveCount > 2 else { return false }
        return (Double(isOffensiveCount) / Double(totalInteractionsCount)) > 0.10
    }
    
}

struct SetupRecordKeys {
    static let type = "Setup"
    static let owningPunchLine = "owningPunchLine"
    static let text = "text"
    static let author = "author"
    static let totalInteractionsCount = "totalInteractionsCount"
    static let isUnfunnyCount = "isUnfunnyCount"
    static let isOffensiveCount = "isOffensiveCount"
}
