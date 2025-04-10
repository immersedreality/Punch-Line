//
//  FavoriteJokeListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/1/25.
//

import Foundation
import SwiftUI

class FavoriteJokeListViewModel {

    private var selectedFavoriteJoke: FavoriteJoke?

    var favoriteJokes: [FavoriteJoke] {
        return AppSessionManager.userInfo?.favoriteJokes ?? []
    }

    // MARK: Setters/ Getters
    
    func set(selectedFavoriteJoke: FavoriteJoke) {
        self.selectedFavoriteJoke = selectedFavoriteJoke
    }

    // MARK: Update Methods

    func removeSelectedFavoriteJokeFromFavorites() {
        guard let selectedFavoriteJoke else { return }

        if let favoriteJokeToRemove = favoriteJokes.first(where: { favoriteJoke in
            favoriteJoke.id == selectedFavoriteJoke.id
        }) {
            AppSessionManager.removeFavoriteJoke(with: favoriteJokeToRemove.id)
        }

    }

}
