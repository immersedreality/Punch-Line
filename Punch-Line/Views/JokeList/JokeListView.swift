//
//  JokeListView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/31/25.
//

import SwiftUI

struct JokeListView: View {

    let viewModel: JokeListViewModel

    @State private var showingConfirmationDialog = false
    @State private var showingModalSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.top])
                List(viewModel.jokes) { joke in
                    JokeView(joke: joke)
                        .onTapGesture {
                            showingConfirmationDialog = true
                            viewModel.selectedJoke = joke
                        }
                        .confirmationDialog("", isPresented: $showingConfirmationDialog) {
                            if viewModel.selectedJokeIsAlreadyFavorited() {
                                Button("Remove from Favorites") {
                                    viewModel.removeSelectedJokeFromFavorites()
                                }
                            } else {
                                Button("Add to Favorites") {
                                    viewModel.addSelectedJokeToFavorites()
                                }
                            }
                        }
                }
                .listRowSpacing(8.0)
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(ImageTitles.iconNavigationTitle)
                        .foregroundStyle(.accent)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: SystemIcons.gear)
                        .foregroundStyle(.accent)
                        .onTapGesture {
                            showingModalSheet = true
                        }
                        .sheet(isPresented: $showingModalSheet) {
                            SettingsView()
                                .presentationDragIndicator(.visible)
                        }
                }
            }
            .navigationTitle(viewModel.displayDate)
        }
    }

}

struct JokeView: View {

    let joke: Joke

    var body: some View {
        HStack(spacing: 4.0) {
            VStack {
                if let dayRanking = joke.dayRanking?.description {
                    HStack {
                        Spacer()
                        Text("#" + dayRanking)
                            .font(Font.system(size: 32.0, weight: .bold))
                            .foregroundStyle(.accent)
                            .padding([.bottom], 2.0)
                        Spacer()
                    }
                }
                HStack {
                    Text(joke.setup)
                        .font(Font.system(size: 20.0, weight: .light))
                        .foregroundStyle(.accent)
                    Spacer(minLength: 16.0)
                }
                HStack {
                    Spacer(minLength: 16.0)
                    Text(joke.punchline)
                        .font(Font.system(size: 20.0, weight: .semibold))
                        .foregroundStyle(.accent)
                        .padding([.top], 2.0)
                }
                if let setupAuthor = joke.setupAuthorUsername {
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
                if let punchlineAuthor = joke.punchlineAuthorUsername {
                    HStack(spacing: 0.0) {
                        Text("Punchline By -> ")
                            .font(Font.system(size: 12.0, weight: .light))
                            .foregroundStyle(.gray)
                            .padding([.top], joke.setupAuthorUsername == nil ? 8.0 : 0.0)
                        Text(punchlineAuthor)
                            .font(Font.system(size: 12.0, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding([.top], joke.setupAuthorUsername == nil ? 8.0 : 0.0)
                        Spacer(minLength: 16.0)
                    }
                }
            }
        }
    }

}

#Preview {
    JokeListView(
        viewModel: JokeListViewModel(
            displayDate: TestDataManager.testDateDisplayString,
            jokes: TestDataManager.getRandomJokes(for: UUID().uuidString)
        )
    )
}
