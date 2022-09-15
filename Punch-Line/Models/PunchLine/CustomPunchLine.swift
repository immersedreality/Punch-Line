//
//  CustomPunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct CustomPunchLine: PunchLine {

    let id: String
    let owningUser: User
    let name: String

    let activeSetups: [Setup] = []
    let activeJokes: [Joke] = []
    let survivingJokes: [Joke] = []
    
    let memberIDs: [String] = []
    
}

enum CustomPunchLineRecordKeys: String {
    case type = "CustomPunchLine"
}

extension CustomPunchLine {
    var record: CKRecord {
        let record = CKRecord(recordType: CustomPunchLineRecordKeys.type.rawValue)
        return record
    }
}
