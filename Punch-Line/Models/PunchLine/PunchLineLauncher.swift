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

    let id: String
    let name: String
    let type: PunchLineLauncherType
    let publicScope: PublicScope?
    
}

enum PunchLineLauncherType: String {
    case publicLauncher, customLauncher
}

enum PunchLineLauncherRecordKeys: String {
    case type = "PunchLineLauncher"
}

extension PunchLineLauncher {
    var record: CKRecord {
        let record = CKRecord(recordType: PunchLineLauncherRecordKeys.type.rawValue)
        return record
    }
}
