//
//  JokeListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/31/25.
//

import SwiftUI

class JokeListViewModel {

    let displayDate: String
    let jokes: [HistoryJoke]
    let mode: JokeListMode
    private var selectedJoke: HistoryJoke?

    init(displayDate: String, jokes: [HistoryJoke], mode: JokeListMode) {
        self.displayDate = displayDate
        self.jokes = jokes
        self.mode = mode
    }

    // MARK: Setters/Getters

    func set(selectedJoke: HistoryJoke) {
        self.selectedJoke = selectedJoke
    }

    func getNavigationTitle() -> String {
        switch mode {
        case .history:
            return displayDate
        case .lookup:
            return NavigationTitles.jokeLookup
        }
    }

    // MARK: Update Methods

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

    // MARK: Validators

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

    // MARK: Sharing

    func copyShareableJokeString() {
        guard let selectedJoke else { return }
        UIPasteboard.general.string = selectedJoke.setup + "\n\n" + selectedJoke.punchline + "\n\n" + ConfirmationDialogMessages.shareMessage
    }

}

enum JokeListMode {
    case history, lookup
}
