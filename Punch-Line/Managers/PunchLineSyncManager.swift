//
//  PunchLineSyncManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

final class PunchLineSyncManager {

    typealias AccessPath = String

    class func generatePublicPunchLinesForNewCloudInstance() -> [PublicPunchLine] {

        var publicPunchLinesForNewCloudInstance: [PublicPunchLine] = []

        for punchLineName in PublicPunchLineNames.MajorRegions.regionNamesForNewCloudInstance {
            let publicPunchLine = generatePublicPunchLine(with: punchLineName, scope: .major)
            publicPunchLinesForNewCloudInstance.append(publicPunchLine)
        }

        for punchLineName in PublicPunchLineNames.MidSizedRegions.regionNamesForNewCloudInstance {
            let publicPunchLine = generatePublicPunchLine(with: punchLineName, scope: .mid)
            publicPunchLinesForNewCloudInstance.append(publicPunchLine)
        }

        for punchLineName in PublicPunchLineNames.LocalRegions.regionNamesForNewCloudInstance {
            let publicPunchLine = generatePublicPunchLine(with: punchLineName, scope: .local)
            publicPunchLinesForNewCloudInstance.append(publicPunchLine)
        }

        return publicPunchLinesForNewCloudInstance

    }

    class func generatePublicPunchLine(with name: String, scope: PublicScope) -> PublicPunchLine {
        let newPublicPunchLine = PublicPunchLine()
        newPublicPunchLine.name = name
        newPublicPunchLine.setScope(to: scope)
        return newPublicPunchLine
    }

    class func generateCustomPunchLine(with name: String) -> CustomPunchLine? {
        guard let loggedInUser = AppSession.sharedInstance.loggedInUser else { return nil }
        let newCustomPunchLine = CustomPunchLine()
        newCustomPunchLine.name = name
        newCustomPunchLine.ownerID = loggedInUser.id
        newCustomPunchLine.memberIDs.append(newCustomPunchLine.ownerID)
        return newCustomPunchLine
    }

    class func generateLauncher(from punchLine: PunchLine) -> PunchLineLauncher {
        let newPunchLineLauncher = PunchLineLauncher()
        newPunchLineLauncher.id = punchLine.id
        newPunchLineLauncher.name = punchLine.name
        return newPunchLineLauncher
    }

    class func generateLauncherIfNeededFromPunchLine(at accessPath: AccessPath) {
        if let punchLine = RealmAccessManager.getObjects(of: PublicPunchLine.self, fromRealmAt: accessPath)?.first {
            let launcher = generateLauncher(from: punchLine)
            launcher.setType(to: .publicLauncher)
            launcher.setPublicScope(to: punchLine.getScope())
            RealmAccessManager.addOrUpdate(object: launcher, inRealmAt: RealmSyncConstants.userPath)
        } else if let punchLine = RealmAccessManager.getObjects(of: CustomPunchLine.self, fromRealmAt: accessPath)?.first {
            let launcher = generateLauncher(from: punchLine)
            launcher.setType(to: .customLauncher)
            RealmAccessManager.addOrUpdate(object: launcher, inRealmAt: RealmSyncConstants.userPath)
        }
    }

    class func matchPublicPunchLineNames(to locationMap: PublicPunchLineLocationMap, completion: @escaping (Bool) -> Void) {
        var matchedPublicPunchLineNames: [String] = []

        if let matchedMidSizeRegionName = PublicPunchLineNames.MidSizedRegions.regionNamesForNewCloudInstance
            .first(where: { (regionName) -> Bool in
                guard let midSizeRegionName = locationMap.administrativeArea else { return false }
                return regionName == midSizeRegionName
        }) {
            matchedPublicPunchLineNames.append(matchedMidSizeRegionName)
        }

        if let matchedLocalRegionName = PublicPunchLineNames.LocalRegions.regionNamesForNewCloudInstance
            .first(where: { (regionName) -> Bool in
                guard let localRegionName = locationMap.locality else { return false }
                return regionName == localRegionName
        }) {
            matchedPublicPunchLineNames.append(matchedLocalRegionName)
        }

        let currentPublicPunchLineLaunchers = AppSession.sharedInstance.loggedInUser?.publicPunchLineLaunchers ?? List<PunchLineLauncher>()
        let matchedRealmAccessPaths = matchedPublicPunchLineNames
            .map { "/" + $0.removingSpaces() }
            .filter { (accessPath) -> Bool in
                return currentPublicPunchLineLaunchers.contains { (launcher) -> Bool in
                    launcher.realmPath == accessPath
                } == false
        }

        guard matchedRealmAccessPaths.isEmpty == false else { completion(false); return }
        RealmSyncManager.sync(withRealmsAt: matchedRealmAccessPaths) {
            completion(true)
        }

    }

}
