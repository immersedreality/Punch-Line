//
//  LocalRealmManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

final class LocalRealmManager {

    typealias PrimaryKey = String
    
    class func getLocalObject<T: Object>(of type: T.Type, with primaryKey: PrimaryKey) -> T? {
        let configuration = Realm.Configuration()
        guard let realm = try? Realm(configuration: configuration) else { return nil }
        return realm.object(ofType: T.self, forPrimaryKey: primaryKey)
    }

    class func addOrUpdateLocalUnmanaged(object: Object) {
        let configuration = Realm.Configuration()
        guard let realm = try? Realm(configuration: configuration) else { return }
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }

    @discardableResult
    class func createLocalCopyOf<T: Object>(object: T) -> T? {
        let configuration = Realm.Configuration()
        guard let realm = try? Realm(configuration: configuration) else { return nil }

        var localCopyOfObject: T?
        try? realm.write {
            localCopyOfObject = realm.create(T.self, value: object, update: .modified)
        }

        return localCopyOfObject
    }

}
