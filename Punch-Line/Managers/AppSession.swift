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

    static let sharedInstance = LocalRealmManager.getLocalObject(of: AppSession.self, with: PrimaryKeys.appSessionKey) ?? AppSession()

    @objc dynamic var id = PrimaryKeys.appSessionKey
    @objc dynamic var loggedInUser: LocalUser?

    override class func primaryKey() -> String? {
        return PrimaryKeys.id
    }

    override class func ignoredProperties() -> [String] {
        return [
            IgnoredProperties.sharedInstance
        ]
    }

}
