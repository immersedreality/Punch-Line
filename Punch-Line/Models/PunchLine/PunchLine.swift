//
//  PunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

protocol PunchLine {
    var cloudKitID: CKRecord.ID { get }
    var owningLauncher: CKRecord.Reference { get }
    var displayName: String { get }
}
