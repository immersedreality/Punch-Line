//
//  SurvivingJoke.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/29/25.
//

import Foundation

struct SurvivingJoke: Codable, Identifiable {

    let id: String
    let entryID: String
    let punchLineID: String
    let punchLineDisplayName: String
    let punchLineType: PunchLineType

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

enum PunchLineType: String, Codable {
    case publicPunchLine, privatePunchLine
}
