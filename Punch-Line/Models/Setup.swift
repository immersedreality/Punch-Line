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
    let authorUsername: String?

    let isOffensive: Bool

}

struct SetupPostRequest: Codable {
    let punchLineID: String
    let text: String
    let authorID: String
    let authorUsername: String?
}

enum SetupReportReason: String {
    case offensive, unfunny
}
