//
//  PunchLineRelauncher.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/22/25.
//

import Foundation

struct PunchLineRelauncher {
    let previouslyFetchedSetups: [Setup]
    let previouslyFetchedJokes: [Joke]
    let currentSetup: Setup?
    let currentJoke: Joke?
}
