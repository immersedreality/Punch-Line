//
//  UserInformation.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class LoggedInUserInformation: Object {

    @objc dynamic var username: String = ""
    @objc dynamic var shouldSeeOffensiveContent: Bool = true

    let survivingJokes = List<Joke>()
    let favoritedJokes = List<Joke>()

    override class func primaryKey() -> String? {
        return PrimaryKeys.username
    }

}
