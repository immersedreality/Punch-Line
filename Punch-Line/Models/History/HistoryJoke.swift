//
//  HistoryJoke.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/29/25.
//

import Foundation

struct HistoryJoke: Codable, Identifiable {

    let id: String
    let entryID: String
    let punchLineDisplayName: String

    let setup: String
    let setupAuthorID: String
    let setupAuthorUsername: String?

    let punchline: String
    let punchlineAuthorID: String
    let punchlineAuthorUsername: String?

    let dateCreated: Date
    let dayRanking: Int
    let isOffensive: Bool

}
