//
//  JokeHistoryDate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/26/25.
//

import Foundation

struct JokeHistoryDate: Codable, Identifiable {
    var id: String
    let punchLineID: String
    let date: Date
    let jokes: [Joke]

    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
}
