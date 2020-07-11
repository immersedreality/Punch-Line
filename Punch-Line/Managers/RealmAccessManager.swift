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

    private static let permissionsSyncDispatchGroup = DispatchGroup()
    private static let initialSyncDispatchGroup = DispatchGroup()

    class func initialAdminSync(completion: @escaping (Bool) -> Void) {
        applyPublicPermissions { (permissionsWereGranted) in
            if permissionsWereGranted {
                initialSync(completion: completion)
            } else {
                completion(false)
            }
        }
    }
    
    private class func applyPublicPermissions(completion: @escaping (Bool) -> Void) {
        guard let user = SyncUser.current else { completion(false); return }

        let activityPermission = SyncPermission(realmPath: RealmSyncConstants.activityPath, identity: RealmSyncConstants.all, accessLevel: .write)
        let historyPermission = SyncPermission(realmPath: RealmSyncConstants.historyPath, identity: RealmSyncConstants.all, accessLevel: .write)

        var activityPermissionsAppliedSuccessfully = false
        var historyPermissionsAppliedSuccessfully = false

        permissionsSyncDispatchGroup.enter()
        user.apply(activityPermission) { (error) in
            activityPermissionsAppliedSuccessfully = error == nil
            permissionsSyncDispatchGroup.leave()
        }

        permissionsSyncDispatchGroup.enter()
        user.apply(historyPermission) { (error) in
            historyPermissionsAppliedSuccessfully = error == nil
            permissionsSyncDispatchGroup.leave()
        }

        permissionsSyncDispatchGroup.notify(queue: .main) {
            completion(activityPermissionsAppliedSuccessfully && historyPermissionsAppliedSuccessfully)
        }

    }

    class func initialSync(completion: @escaping (Bool) -> Void) {
        guard let activityConfiguration = configureRealm(with: .activity) else { completion(false); return }
        guard let historyConfiguration = configureRealm(with: .history) else { completion(false); return }
        guard let userConfiguration = configureRealm(with: .user) else { completion(false); return }

        var activityRealmSyncedSuccessfully = false
        var historyRealmSyncedSuccessfully = false
        var userRealmSyncedSuccessfully = false

        initialSyncDispatchGroup.enter()
        Realm.asyncOpen(configuration: activityConfiguration) { (realm, error) in
            activityRealmSyncedSuccessfully = realm != nil && error == nil
            initialSyncDispatchGroup.leave()
        }

        initialSyncDispatchGroup.enter()
        Realm.asyncOpen(configuration: historyConfiguration) { (realm, error) in
            historyRealmSyncedSuccessfully = realm != nil && error == nil
            initialSyncDispatchGroup.leave()
        }

        initialSyncDispatchGroup.enter()
        Realm.asyncOpen(configuration: userConfiguration) { (realm, error) in
            userRealmSyncedSuccessfully = realm != nil && error == nil
            initialSyncDispatchGroup.leave()
        }

        initialSyncDispatchGroup.notify(queue: .main) {
            completion(activityRealmSyncedSuccessfully && historyRealmSyncedSuccessfully && userRealmSyncedSuccessfully)
        }

    }

    class func getObject<T: Object>(of type: T,
             with primaryKey: String,
             fromRealmAt accessPath: RealmAccessPath,
             completion: @escaping (Bool, T?) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false, nil); return }
            guard let object = realm.object(ofType: T.self, forPrimaryKey: primaryKey) else { completion(false, nil); return }
            completion(true, object)
        }

    }

    class func getObjects<T: Object>(of type: T,
             fromRealmAt accessPath: RealmAccessPath,
             completion: @escaping (Bool, Results<T>?) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false, nil); return }
            completion(true, realm.objects(T.self))
        }

    }

    class func addOrUpdate(object: Object,
                     inRealmAt accessPath: RealmAccessPath,
                     completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.add(object, update: .modified)
            }
        }

    }

    class func addOrUpdate(objects: [Object],
                     inRealmAt accessPath: RealmAccessPath,
                     completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.add(objects, update: .modified)
            }
        }

    }

    class func addOrUpdate(objects: List<Object>,
                     inRealmAt accessPath: RealmAccessPath,
                     completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.add(objects, update: .modified)
            }
        }

    }

    class func delete(object: Object,
                inRealmAt accessPath: RealmAccessPath,
                completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.delete(object)
            }
        }

    }

    class func delete(objects: [Object],
                inRealmAt accessPath: RealmAccessPath,
                completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.delete(objects)
            }
        }

    }

    class func delete(objects: List<Object>,
                inRealmAt accessPath: RealmAccessPath,
                completion: @escaping (Bool) -> Void) {
        guard let configuration = configureRealm(with: accessPath) else { return }

        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { (realm, error) in
            guard let realm = realm else { completion(false); return }
            try! realm.write {
                realm.delete(objects)
            }
        }
        
    }

    private class func configureRealm(with accessPath: RealmAccessPath) -> Realm.Configuration? {
        var urlString = RealmSyncConstants.realmsPrefix + RealmSyncConstants.realmInstanceLink

        switch accessPath {
        case .activity:
            urlString.append(RealmSyncConstants.activityPath)
        case .history:
            urlString.append(RealmSyncConstants.historyPath)
        case .user:
            urlString.append(RealmSyncConstants.userPath)
        }

        guard let url = URL(string: urlString) else { return nil }
        guard let user = SyncUser.current else { return nil }
        let configuration = user.configuration(realmURL: url, fullSynchronization: true)
        return configuration
    }

}

enum RealmAccessPath {
    case activity, history, user
}
