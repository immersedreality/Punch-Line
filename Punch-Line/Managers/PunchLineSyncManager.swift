//
//  PunchLineSyncManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

final class PunchLineSyncManager {

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

    class func matchedPublicPunchLineNames() -> [String] {
        let matchedPublicPunchLineNames: [String] = []
        return matchedPublicPunchLineNames
    }
    
    class func generateCustomPunchLine(with name: String) {
        guard let loggedInUser = AppSession.sharedInstance.loggedInUser else { return }
        let newCustomPunchLine = CustomPunchLine()
        newCustomPunchLine.name = name
        newCustomPunchLine.ownerID = loggedInUser.id
        newCustomPunchLine.memberIDs.append(newCustomPunchLine.ownerID)
    }

}
