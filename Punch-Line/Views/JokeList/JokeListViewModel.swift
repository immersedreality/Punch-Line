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
    var selectedJoke: Joke?

    init(displayDate: String, jokes: [Joke]) {
        self.displayDate = displayDate
        self.jokes = jokes
    }

    func selectedJokeIsAlreadyFavorited() -> Bool {
        guard let favoriteJokes = AppSessionManager.userInfo?.favoriteJokes else { return false }
        guard let selectedJoke else { return false}

        if favoriteJokes.contains(where: { favoriteJoke in
            favoriteJoke.originJokeID == selectedJoke.id
        }) {
            return true
        } else {
            return false
        }
        
    }

    func addSelectedJokeToFavorites() {
        guard let selectedJoke else { return }
        AppSessionManager.addFavoriteJoke(from: selectedJoke)
        self.selectedJoke = nil
    }

    func removeSelectedJokeFromFavorites() {
        guard let favoriteJokes = AppSessionManager.userInfo?.favoriteJokes else { return }
        guard let selectedJoke else { return }

        if let favoriteJokeToRemove = favoriteJokes.first(where: { favoriteJoke in
            favoriteJoke.originJokeID == selectedJoke.id
        }) {
            AppSessionManager.removeFavoriteJoke(with: favoriteJokeToRemove.id)
        }

    }

}
