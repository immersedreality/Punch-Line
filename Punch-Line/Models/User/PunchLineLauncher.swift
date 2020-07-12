//
//  PunchLineLauncher.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class PunchLineLauncher: Object {

    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""

    var nameWithoutSpaces: String {
        return name.removingSpaces()
    }

    var realmPath: String {
        return "/" + nameWithoutSpaces
    }
    
    override class func primaryKey() -> String? {
        return PrimaryKeys.id
    }

    override class func ignoredProperties() -> [String] {
        return [
            IgnoredProperties.nameWithoutSpaces,
            IgnoredProperties.realmPath
        ]
    }
    
}
