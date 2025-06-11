//
//  JokeListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/31/25.
//

import SwiftUI

class JokeListViewModel: ObservableObject {

    let displayDate: String
    var entryID: String? = nil
    @Published var jokes: [SurvivingJoke] = []
    let mode: JokeListMode
    private var selectedJoke: SurvivingJoke?

    init(displayDate: String, entryID: String, mode: JokeListMode) {
        self.displayDate = displayDate
        self.entryID = entryID
        self.mode = mode
    }

    init(displayDate: String, jokes: [SurvivingJoke], mode: JokeListMode) {
        self.displayDate = displayDate
        self.jokes = jokes
        self.mode = mode
    }

    func fetchJokes() {
        guard let entryID else { return }
        DispatchQueue.main.async {
            Task {
                await self.jokes = APIManager.getSurvivingJokes(for: entryID)
            }
        }
    }

    // MARK: Setters/Getters

    func set(selectedJoke: SurvivingJoke) {
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

        self.selectedJoke = nil
    }

    func deleteJoke() {
        guard let selectedJoke else { return }
        DispatchQueue.main.async {
            Task {
                if await APIManager.deleteSurvivingJoke(with: selectedJoke.id) {
                    self.jokes.removeAll { $0.id == selectedJoke.id }
                }
            }
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
