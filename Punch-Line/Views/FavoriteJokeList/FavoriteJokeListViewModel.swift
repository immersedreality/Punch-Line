//
//  FavoriteJokeListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/1/25.
//

import Foundation
import SwiftUI

class FavoriteJokeListViewModel {

    var favoriteJokes: [FavoriteJoke] {
        return AppSessionManager.userInfo?.favoriteJokes ?? []
    }

    func removeJokeFromFavorites(favoriteJoke: FavoriteJoke) {
        AppSessionManager.removeFavoriteJoke(with: favoriteJoke.id)
    }

}
