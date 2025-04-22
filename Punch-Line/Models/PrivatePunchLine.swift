//
//  PrivatePunchLine.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import Foundation

struct PrivatePunchLine: Codable, Identifiable {
    let id: String
    let displayName: String
    let joinCode: String
    let owningUserID: String
    let owningUserName: String
    let lastDailyResetDate: Date
}

struct PrivatePunchLinePostRequest: Codable {
    let displayName: String
    let owningUserID: String
    let owningUserName: String
}
