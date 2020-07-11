//
//  RealmAccessManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmAccessManager {

    typealias AccessPath = String
    typealias PrimaryKey = String

    class func configureRealm(withRealmAt accessPath: AccessPath) -> Realm.Configuration? {
        let urlString = RealmSyncConstants.realmsPrefix + RealmSyncConstants.realmInstanceLink + accessPath
        guard let url = URL(string: urlString) else { return nil }
        guard let user = SyncUser.current else { return nil }

        let configuration = user.configuration(realmURL: url, fullSynchronization: true)
        return configuration
    }

    class func getObject<Type: Object>(of type: Type, with primaryKey: PrimaryKey, fromRealmAt accessPath: AccessPath) -> Type? {
        guard let configuration = configureRealm(withRealmAt: accessPath) else { return nil }
        guard let realm = try? Realm(configuration: configuration) else { return nil }
        return realm.object(ofType: Type.self, forPrimaryKey: primaryKey)
    }

    class func getObjects<Type: Object>(of type: Type, fromRealmAt accessPath: AccessPath) -> Results<Type>? {
        guard let configuration = configureRealm(withRealmAt: accessPath) else { return nil }
        guard let realm = try? Realm(configuration: configuration) else { return nil }
        return realm.objects(Type.self)
    }

    class func addOrUpdate(object: Object, inRealmAt accessPath: AccessPath) {
        guard let configuration = configureRealm(withRealmAt: accessPath) else { return }
        guard let realm = try? Realm(configuration: configuration) else { return }
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }

    class func addOrUpdate(objects: [Object], inRealmAt accessPath: AccessPath) {
        guard let configuration = configureRealm(withRealmAt: accessPath) else { return }
        guard let realm = try? Realm(configuration: configuration) else { return }
        try? realm.write {
            realm.add(objects, update: .modified)
        }
    }

    class func addOrUpdate(objects: List<Object>, inRealmAt accessPath: AccessPath) {
        guard let configuration = configureRealm(withRealmAt: accessPath) else { return }
        guard let realm = try? Realm(configuration: configuration) else { return }
        try? realm.write {
            realm.add(objects, update: .modified)
        }
    }

    class func delete(object: Object, inRealmAt accessPath: AccessPath) {
        guard let configuration = configureRealm(withRealmAt: accessPath) else { return }
        guard let realm = try? Realm(configuration: configuration) else { return }
        try? realm.write {
            realm.delete(object)
        }
    }

    class func delete(objects: [Object], inRealmAt accessPath: AccessPath) {
        guard let configuration = configureRealm(withRealmAt: accessPath) else { return }
        guard let realm = try? Realm(configuration: configuration) else { return }
        try? realm.write {
            realm.delete(objects)
        }
    }

    class func delete(objects: List<Object>, inRealmAt accessPath: AccessPath) {
        guard let configuration = configureRealm(withRealmAt: accessPath) else { return }
        guard let realm = try? Realm(configuration: configuration) else { return }
        try? realm.write {
            realm.delete(objects)
        }
    }

}
