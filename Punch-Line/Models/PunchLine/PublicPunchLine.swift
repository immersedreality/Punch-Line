//
//  PublicPunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/31/25.
//

import Foundation

struct PublicPunchLine: ActivePunchLine, Codable, Identifiable {
    let id: String
    let displayName: String
    let historyEntryGroups: [JokeHistoryEntryGroup]
    let lastDailyResetDate: Date
}
