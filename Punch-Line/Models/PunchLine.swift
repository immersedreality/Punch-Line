//
//  PunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class PunchLine: Object {

    @objc dynamic var id: String = UUID().uuidString

    override class func primaryKey() -> String? {
        return PrimaryKeys.id
    }

}
