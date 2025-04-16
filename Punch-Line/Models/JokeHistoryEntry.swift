//
//  JokeHistoryEntry.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/26/25.
//

import Foundation

struct JokeHistoryEntry: Codable, Identifiable {

    let id: String
    let entryGroupID: String
    let punchLineID: String

    let date: Date
    let jokes: [Joke]
    
}
