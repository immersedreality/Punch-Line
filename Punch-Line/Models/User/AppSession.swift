//
//  AppSession.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class AppSession: Object {

    static var sharedInstance = RealmAccessManager.getObject(
        of: AppSession.self,
        with: PrimaryKeys.appSessionKey,
        fromRealmAt: RealmSyncConstants.userPath) ?? AppSession()

    @objc dynamic var id = PrimaryKeys.appSessionKey
    @objc dynamic var loggedInUser: AppUser?
    
    override class func primaryKey() -> String? {
        return PrimaryKeys.id
    }

    override class func ignoredProperties() -> [String] {
        return [
            IgnoredProperties.userAccessPath,
            IgnoredProperties.sharedInstance
        ]
    }

}
