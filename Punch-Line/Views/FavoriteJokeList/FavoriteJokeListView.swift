//
//  FavoriteJokeListView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/1/25.
//

import SwiftUI

struct FavoriteJokeListView: View {

    let viewModel = FavoriteJokeListViewModel()

    @State private var showingConfirmationDialog = false
    @State private var shouldNavigateBackToSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.vertical])
                List(viewModel.favoriteJokes) { favoriteJoke in
                    FavoriteJokeView(favoriteJoke: favoriteJoke)
                        .onTapGesture {
                            showingConfirmationDialog = true
                            viewModel.set(selectedFavoriteJoke: favoriteJoke)
                        }
                        .confirmationDialog("", isPresented: $showingConfirmationDialog) {
                            Button("Remove from Favorites") {
                                viewModel.removeSelectedFavoriteJokeFromFavorites()
                                if AppSessionManager.userInfo?.favoriteJokes.isEmpty == true {
                                    shouldNavigateBackToSettings = true
                                }
                            }
                        }
                }
                .listRowSpacing(8.0)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(NavigationTitles.favoriteJokes)
        }
        .navigationDestination(isPresented: $shouldNavigateBackToSettings) {
            SettingsView()
        }
    }

}

struct FavoriteJokeView: View {

    let favoriteJoke: FavoriteJoke

    var body: some View {
        HStack(spacing: 4.0) {
            VStack {
                HStack {
                    Text(favoriteJoke.setup)
                        .font(Font.system(size: 20.0, weight: .light))
                    Spacer(minLength: 16.0)
                }
                HStack {
                    Spacer(minLength: 16.0)
                    Text(favoriteJoke.punchline)
                        .font(Font.system(size: 20.0, weight: .semibold))
                        .padding([.top], 2.0)
                }
                if let setupAuthor = favoriteJoke.setupAuthorUsername {
                    HStack(spacing: 0.0) {
                        Text("Setup By -> ")
                            .font(Font.system(size: 12.0, weight: .light))
                            .foregroundStyle(.gray)
                            .padding([.top], 8.0)
                        Text(setupAuthor)
                            .font(Font.system(size: 12.0, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding([.top], 8.0)
                        Spacer(minLength: 16.0)
                    }
                }
                if let punchlineAuthor = favoriteJoke.punchlineAuthorUsername {
                    HStack(spacing: 0.0) {
                        Text("Punchline By -> ")
                            .font(Font.system(size: 12.0, weight: .light))
                            .foregroundStyle(.gray)
                            .padding([.top], favoriteJoke.setupAuthorUsername == nil ? 8.0 : 0.0)
                        Text(punchlineAuthor)
                            .font(Font.system(size: 12.0, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding([.top], favoriteJoke.setupAuthorUsername == nil ? 8.0 : 0.0)
                        Spacer(minLength: 16.0)
                    }
                }
            }
        }
    }

}

#Preview {
    FavoriteJokeListView()
}
