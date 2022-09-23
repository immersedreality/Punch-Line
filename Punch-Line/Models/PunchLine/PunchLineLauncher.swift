//
//  PunchLineLauncher.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct PunchLineLauncher {

    let identifier: String
    let displayName: String
    let scope: PunchLineScope

}

struct PunchLineLauncherRecordKeys {
    static let type = "PunchLineLauncher"
    static let identifier = "identifier"
    static let displayName = "displayName"
    static let scope = "scope"
}

extension PunchLineLauncher {
    var record: CKRecord {
        let record = CKRecord(recordType: PunchLineLauncherRecordKeys.type)
        record[PunchLineLauncherRecordKeys.identifier] = identifier as CKRecordValue
        record[PunchLineLauncherRecordKeys.displayName] = displayName as CKRecordValue
        record[PunchLineLauncherRecordKeys.scope] = scope.rawValue as CKRecordValue
        return record
    }
}