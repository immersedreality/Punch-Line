//
//  Setup.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import Foundation

struct Setup: Codable, Identifiable {

    let id: String
    let punchLineID: String

    let text: String
    let authorID: String
    let autherUsername: String?

    let totalInteractionsCount: Int
    let isUnfunnyCount: Int
    let isOffensiveCount: Int

    var isUnfunny: Bool {
        guard totalInteractionsCount > 10 else { return false }
        return (Double(isUnfunnyCount) / Double(totalInteractionsCount)) > 0.25
    }

    var isOffensive: Bool {
        guard isOffensiveCount > 2 else { return false }
        return (Double(isOffensiveCount) / Double(totalInteractionsCount)) > 0.10
    }

}
