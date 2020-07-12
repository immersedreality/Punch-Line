//
//  AppUser.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class AppUser: Object {

    @objc dynamic var id: String = ""

    @objc dynamic var username: String = ""
    @objc dynamic var shouldSeeOffensiveContent: Bool = true
    
    var publicPunchLineLaunchers = List<PunchLineLauncher>()
    let customPunchLineLaunchers = List<PunchLineLauncher>()
    let favoritedJokes = List<FavoriteJoke>()

    override class func primaryKey() -> String? {
        return PrimaryKeys.id
    }

}
