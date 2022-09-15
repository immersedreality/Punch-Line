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

    let id: String
    let scope: PublicScope
    let name: String

    let activeSetups: [Setup] = []
    let activeJokes: [Joke] = []
    let survivingJokes: [Joke] = []

}

enum PublicPunchLineRecordKeys: String {
    case type = "PublicPunchLine"
}

extension PublicPunchLine {
    var record: CKRecord {
        let record = CKRecord(recordType: PublicPunchLineRecordKeys.type.rawValue)
        return record
    }
}
