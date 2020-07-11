//
//  Setup.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class Setup: Object {

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var dateCreated: Date = Date()

    @objc dynamic var text: String = ""
    @objc dynamic var author: String = ""

    @objc dynamic var isOffensiveCount: Int = 0
    @objc dynamic var isUnfunnyCount: Int = 0
    
    override class func primaryKey() -> String? {
        return PrimaryKeys.id
    }
    
}
