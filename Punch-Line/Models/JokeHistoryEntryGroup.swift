//
//  JokeHistoryEntryGroup.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/2/25.
//

import Foundation

struct JokeHistoryEntryGroup: Codable, Identifiable {

    let id: String
    let punchLineID: String
    let year: Int
    let month: Int

    var displayMonth: String {
        DateFormatter().monthSymbols[month-1].capitalized
    }

}
