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
    @objc private dynamic var type: String = ""

    var nameWithoutSpaces: String {
        return name.removingSpaces()
    }

    var realmPath: String {
        return "/" + nameWithoutSpaces
    }

    func setType(to type: PunchLineLauncherType) {
        self.type = type.rawValue
    }

    func getType() -> PunchLineLauncherType {
        return PunchLineLauncherType(rawValue: type) ?? .publicLauncher
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

enum PunchLineLauncherType: String {
    case publicLauncher, customLauncher
}
