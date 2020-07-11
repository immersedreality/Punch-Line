//
//  PunchLineSyncManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

final class PunchLineSyncManager {

    class func generatePublicPunchLine(with name: String, completion: @escaping (Bool) -> Void) {
        let newPublicPunchLine = PublicPunchLine()
        newPublicPunchLine.name = name
    }

    class func generateCustomPunchLine(with name: String) {
        guard let loggedInUser = AppSession.sharedInstance.loggedInUser else { return }
        let newCustomPunchLine = CustomPunchLine()
        newCustomPunchLine.name = name
        newCustomPunchLine.ownerID = loggedInUser.id
        newCustomPunchLine.memberIDs.append(newCustomPunchLine.ownerID)
    }

}
