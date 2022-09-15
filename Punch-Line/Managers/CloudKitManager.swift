//
//  CloudKitManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

final class CloudKitManager {

    private static let container = CKContainer.default()
    
    class func accountIsAvailable() async -> Bool {

        do {
            let accountStatus = try await container.accountStatus()

            switch accountStatus {
            case .available:
                return true
            case .couldNotDetermine, .noAccount, .restricted, .temporarilyUnavailable:
                return false
            @unknown default:
                return false
            }
        } catch {
            return false
        }

    }

    class func requestUserDiscoverabilityPermission() async -> Bool {

        do {
            let accountPermissionStatus  = try await container.requestApplicationPermission(.userDiscoverability)

            switch accountPermissionStatus {
            case .granted:
                return true
            case .couldNotComplete, .denied, .initialState:
                return false
            @unknown default:
                return false
            }
        } catch {
            return false
        }

    }

    class func getUserFromPrivateDatebase() {

    }

    class func saveUserToPrivateDatabase(user: User) {
        let privateDatabase = container.privateCloudDatabase
        let userRecord = user.record
        privateDatabase.save(userRecord) { savedRecord, error in
            #warning("TODO: Handle error")
        }
    }

    class func matchPublicPunchLineNames(to locationMap: PublicPunchLineLocationMap, completion: @escaping (Bool) -> Void) {
        var matchedPublicPunchLineNames: [String] = []

        if let matchedMidSizeRegionName = MatchablePublicPunchLines.StatesAndProvinces.activeRegions
            .first(where: { (regionName) -> Bool in
                guard let midSizeRegionName = locationMap.administrativeArea else { return false }
                return regionName == midSizeRegionName
            }) {
            matchedPublicPunchLineNames.append(matchedMidSizeRegionName)
        }

        if let matchedLocalRegionName = MatchablePublicPunchLines.Cities.activeRegions
            .first(where: { (regionName) -> Bool in
                guard let localRegionName = locationMap.locality else { return false }
                return regionName == localRegionName
            }) {
            matchedPublicPunchLineNames.append(matchedLocalRegionName)
        }

        #warning("TODO: Sync matched public punchlines with iCloud databases")
        
        completion(true)

    }

}
