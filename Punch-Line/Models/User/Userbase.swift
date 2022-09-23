//
//  Userbase.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 9/23/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit


struct Userbase {
    let allUsernames: [String]
}

struct UserbaseRecordKeys {
    static let type = "Userbase"
    static let allUsernames = "allUsernames"
}
