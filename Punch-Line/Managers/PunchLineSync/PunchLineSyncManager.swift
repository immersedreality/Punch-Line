//
//  PunchLineSyncManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

final class PunchLineSyncManager: NSObject {

    typealias AccessPath = String

    class func generatePublicPunchLinesForNewCloudInstance() -> [PublicPunchLine] {

        var publicPunchLinesForNewCloudInstance: [PublicPunchLine] = []

        for punchLineName in PublicPunchLineNames.MajorRegions.regionNamesForNewCloudInstance {
            let publicPunchLine = generatePublicPunchLine(with: punchLineName)
            publicPunchLinesForNewCloudInstance.append(publicPunchLine)
        }

        for punchLineName in PublicPunchLineNames.MidSizedRegions.regionNamesForNewCloudInstance {
            let publicPunchLine = generatePublicPunchLine(with: punchLineName)
            publicPunchLinesForNewCloudInstance.append(publicPunchLine)
        }

        for punchLineName in PublicPunchLineNames.LocalRegions.regionNamesForNewCloudInstance {
            let publicPunchLine = generatePublicPunchLine(with: punchLineName)
            publicPunchLinesForNewCloudInstance.append(publicPunchLine)
        }

        return publicPunchLinesForNewCloudInstance

    }

    class func generatePublicPunchLine(with name: String) -> PublicPunchLine {
        let newPublicPunchLine = PublicPunchLine()
        newPublicPunchLine.name = name
        return newPublicPunchLine
    }

    class func matchPublicPunchLineNames(to locationMap: PublicPunchLineLocationMap) {
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
                guard let localRegionName = locationMap.administrativeArea else { return false }
                return regionName == localRegionName
        }) {
            matchedPublicPunchLineNames.append(matchedLocalRegionName)
        }

        let matchedRealmAccessPaths = matchedPublicPunchLineNames.map { $0.removingSpaces() }

        RealmSyncManager.sync(withRealmsAt: matchedRealmAccessPaths) { (_) in }
        
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
            RealmAccessManager.addOrUpdate(object: launcher, inRealmAt: RealmSyncConstants.userPath)
        } else if let punchLine = RealmAccessManager.getObjects(of: CustomPunchLine.self, fromRealmAt: accessPath)?.first {
            let launcher = generateLauncher(from: punchLine)
            launcher.setType(to: .customLauncher)
            RealmAccessManager.addOrUpdate(object: launcher, inRealmAt: RealmSyncConstants.userPath)
        }
    }

}
