//
//  PunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/31/25.
//

import Foundation

struct PunchLine: Codable, Identifiable {
    let id: String
    let displayName: String
    let owningUserID: String?
    let participantUserIDs: [String]?
    let scope: PunchLineScope
    let lastDailyResetDate: Date
}

enum PunchLineScope: String, Codable {
    case regional, topical, custom
}
