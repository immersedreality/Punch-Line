//
//  CustomPunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class CustomPunchLine: Object, PunchLine {

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var ownerID: String = ""

    @objc dynamic var name: String = ""

    let activeSetups = List<Setup>()
    let activeJokes = List<Joke>()
    let survivingJokes = List<Joke>()
    
    let memberIDs = List<String>()

    var nameWithoutSpaces: String {
        return name.removingSpaces()
    }

    var realmPath: String {
        return "/" + ownerID + "/" + nameWithoutSpaces
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
