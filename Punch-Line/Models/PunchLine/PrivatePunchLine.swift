//
//  PrivatePunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import Foundation

struct PrivatePunchLine: ActivePunchLine, Codable, Identifiable {
    let id: String
    let displayName: String
    let historyEntryGroups: [JokeHistoryEntryGroup]
    let joinCode: String
    let owningUserID: String
    let owningUsername: String
    let lastDailyResetDate: Date
}

struct PrivatePunchLinePostRequest: Codable {
    let displayName: String
    let owningUserID: String
    let owningUsername: String
}

struct PrivatePunchLineDeleteResponse: Codable {
    let wasSuccessful: Bool
}
