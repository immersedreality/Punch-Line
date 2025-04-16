//
//  Joke.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import Foundation

struct Joke: Codable, Identifiable {

    let id: String
    let punchLineID: String
    let punchLineDisplayName: String

    let setup: String
    let setupAuthorID: String
    let setupAuthorUsername: String?

    let punchline: String
    let punchlineAuthorID: String
    let punchlineAuthorUsername: String?

    let dateCreated: Date
    let dayRanking: Int?
    let isOffensive: Bool
    
}
