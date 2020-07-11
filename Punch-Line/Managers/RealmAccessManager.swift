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

    private static let initialSyncDispatchGroup = DispatchGroup()

    class func initialAdminSync(completion: @escaping (Bool) -> Void) {
        applyDefaultPermissions { (permissionsWereGranted) in
            if permissionsWereGranted {
                initialSync(completion: completion)
            } else {
                completion(false)
            }
        }
    }
    
    private class func applyDefaultPermissions(completion: @escaping (Bool) -> Void) {
        guard let user = SyncUser.current else { completion(false); return }

        let defaultPunchLinePermission = SyncPermission(realmPath: RealmSyncConstants.defaultRealmPath, identity: RealmSyncConstants.all, accessLevel: .write)

        user.apply(defaultPunchLinePermission) { (error) in
            let permissionsAppliedSuccessfully = error == nil
            completion(permissionsAppliedSuccessfully)
        }

    }

    class func initialSync(completion: @escaping (Bool) -> Void) {
        let defaultPunchLinePath = RealmSyncConstants.defaultRealmPath
        let userPath = RealmSyncConstants.userIdentityPath + RealmSyncConstants.userPath

        guard let defaultConfiguration = configureRealm(with: defaultPunchLinePath) else { completion(false); return }
        guard let userConfiguration = configureRealm(with: userPath) else { completion(false); return }

        var defaultPunchLineSyncedSuccessfully = false
        var userRealmSyncedSuccessfully = false

        initialSyncDispatchGroup.enter()
        Realm.asyncOpen(configuration: defaultConfiguration) { (realm, error) in
            defaultPunchLineSyncedSuccessfully = realm != nil && error == nil
            initialSyncDispatchGroup.leave()
        }

        initialSyncDispatchGroup.enter()
        Realm.asyncOpen(configuration: userConfiguration) { (realm, error) in
            userRealmSyncedSuccessfully = realm != nil && error == nil
            initialSyncDispatchGroup.leave()
        }

        initialSyncDispatchGroup.notify(queue: .main) {
            completion(defaultPunchLineSyncedSuccessfully && userRealmSyncedSuccessfully)
        }

    }

    class func getObject<T: Object>(of type: T,
             with primaryKey: String,
             fromRealmAt accessPath: String,
             completion: @escaping (Bool, T?) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false, nil); return }
            guard let object = realm.object(ofType: T.self, forPrimaryKey: primaryKey) else { completion(false, nil); return }
            completion(true, object)
        }

    }

    class func getObjects<T: Object>(of type: T,
             fromRealmAt accessPath: String,
             completion: @escaping (Bool, Results<T>?) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false, nil); return }
            completion(true, realm.objects(T.self))
        }

    }

    class func addOrUpdate(object: Object,
                     inRealmAt accessPath: String,
                     completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.add(object, update: .modified)
            }
            completion(true)
        }

    }

    class func addOrUpdate(objects: [Object],
                     inRealmAt accessPath: String,
                     completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.add(objects, update: .modified)
            }
            completion(true)
        }

    }

    class func addOrUpdate(objects: List<Object>,
                     inRealmAt accessPath: String,
                     completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.add(objects, update: .modified)
            }
            completion(true)
        }

    }

    class func delete(object: Object,
                inRealmAt accessPath: String,
                completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.delete(object)
            }
            completion(true)
        }

    }

    class func delete(objects: [Object],
                inRealmAt accessPath: String,
                completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.delete(objects)
            }
            completion(true)
        }

    }

    class func delete(objects: List<Object>,
                inRealmAt accessPath: String,
                completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.delete(objects)
            }
            completion(true)
        }
        
    }

    private class func configureRealm(with accessPath: String) -> Realm.Configuration? {
        let urlString = RealmSyncConstants.realmsPrefix + RealmSyncConstants.realmInstanceLink + accessPath
        guard let url = URL(string: urlString) else { return nil }
        guard let user = SyncUser.current else { return nil }

        let configuration = user.configuration(realmURL: url, fullSynchronization: true)
        return configuration
    }

}
