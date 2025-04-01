//
//  FavoriteJoke.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/1/25.
//

import Foundation

struct FavoriteJoke: Codable, Identifiable {
    let id: String
    let dateFavorited: Date
    let setup: String
    let setupAuthorUsername: String?
    let punchline: String
    let punchlineAuthorUsername: String?
}
