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
    let setupID: String
    let setupAuthorID: String
    let setupAuthorUsername: String?

    let punchline: String
    let punchlineAuthorID: String
    let punchlineAuthorUsername: String?

    let dateCreated: Date
    let isOffensive: Bool
    
}

struct JokePostRequest: Codable {
    let punchLineID: String
    let punchLineDisplayName: String
    let setup: String
    let setupID: String
    let setupAuthorID: String
    let setupAuthorUsername: String?
    let punchline: String
    let punchlineAuthorID: String
    let punchlineAuthorUsername: String?
}

struct JokeFetchPostRequest: Codable {
    let requestingUserID: String
    let jokeIDs: [String]
}

struct JokeVoteResponse: Codable {
    let wasSuccessful: Bool
}

struct JokeReportResponse: Codable {
    let wasSuccessful: Bool
}

enum JokeVote: String {
    case ha, meh, ugh
}

enum JokeReportReason: String {
    case offensive, tooFunny
}
