//
//  FavoriteJoke.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteJoke: Object {

    @objc dynamic var id: String = ""

    @objc dynamic var setup: String = ""
    @objc dynamic var setupAuthorID: String = ""

    @objc dynamic var punchline: String = ""
    @objc dynamic var punchlineAuthorID: String = ""

    override class func primaryKey() -> String? {
        return PrimaryKeys.id
    }

}
