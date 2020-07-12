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
    @objc private dynamic var publicScope: Int = 0

    var nameWithoutSpaces: String {
        return name.removingSpaces()
    }

    var realmPath: String {
        return "/" + nameWithoutSpaces
    }

    var sortValue: Int {
        return publicScope
    }

    func setType(to type: PunchLineLauncherType) {
        self.type = type.rawValue
    }

    func getType() -> PunchLineLauncherType {
        return PunchLineLauncherType(rawValue: type) ?? .publicLauncher
    }

    func setPublicScope(to scope: PublicScope) {
        self.publicScope = scope.rawValue
    }

    func getPublicScope() -> PublicScope? {
        return PublicScope(rawValue: publicScope) ?? nil
    }
    
    override class func primaryKey() -> String? {
        return PrimaryKeys.id
    }

    override class func ignoredProperties() -> [String] {
        return [
            IgnoredProperties.nameWithoutSpaces,
            IgnoredProperties.realmPath,
            IgnoredProperties.sortValue
        ]
    }
    
}

enum PunchLineLauncherType: String {
    case publicLauncher, customLauncher
}
