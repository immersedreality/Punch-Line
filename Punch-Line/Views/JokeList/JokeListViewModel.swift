//
//  JokeListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/31/25.
//

import Foundation

class JokeListViewModel {

    let displayDate: String
    let jokes: [Joke]

    init(displayDate: String, jokes: [Joke]) {
        self.displayDate = displayDate
        self.jokes = jokes
    }

}
