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

    let isOffensive: Bool

}
