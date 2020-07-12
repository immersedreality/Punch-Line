//
//  PublicPunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class PublicPunchLine: Object, PunchLine {

    @objc dynamic var id: String = UUID().uuidString

    @objc dynamic var name: String = ""
    @objc private dynamic var scope: Int = 1

    let activeSetups = List<Setup>()
    let activeJokes = List<Joke>()
    let survivingJokes = List<Joke>()

    var nameWithoutSpaces: String {
        return name.removingSpaces()
    }

    var realmPath: String {
        return "/" + nameWithoutSpaces
    }

    func setScope(to scope: PublicScope) {
        self.scope = scope.rawValue
    }

    func getScope() -> PublicScope {
        return PublicScope(rawValue: scope) ?? .major
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

enum PublicScope: Int {
    case major, mid, local
}
