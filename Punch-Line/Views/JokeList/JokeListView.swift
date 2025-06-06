//
//  JokeListView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/31/25.
//

import SwiftUI

struct JokeListView: View {
    
    @ObservedObject var viewModel: JokeListViewModel
//    let adViewModel = InterstitialAdViewModel()
    
    @State private var showingConfirmationDialog = false
    @State private var showingModalSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.mode == .history {
                    StyleManager.jokeListBackgroundColor
                        .ignoresSafeArea(edges: [.top])
                }
                List(viewModel.jokes) { joke in
                    JokeView(joke: joke, mode: viewModel.mode)
                        .onTapGesture {
                            showingConfirmationDialog = true
                            viewModel.set(selectedJoke: joke)
                        }
                }
                .listRowSpacing(8.0)
                .scrollContentBackground(.hidden)
                .confirmationDialog("", isPresented: $showingConfirmationDialog) {
                    if viewModel.selectedJokeIsAlreadyFavorited() {
                        Button(ConfirmationDialogMessages.removeFromFavorites) {
                            viewModel.removeSelectedJokeFromFavorites()
                        }
                    } else {
                        Button(ConfirmationDialogMessages.addToFavorites) {
                            viewModel.addSelectedJokeToFavorites()
                        }
                    }
                    Button(ConfirmationDialogMessages.copyJoke) {
                        viewModel.copyShareableJokeString()
                    }
                }
            }
            .toolbar {
                if viewModel.mode == .history {
                    ToolbarItem(placement: .principal) {
                        Image(ImageTitles.iconNavigationTitle)
                            .foregroundStyle(.accent)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: SystemIcons.settingsButton)
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
            }
            .navigationTitle(viewModel.getNavigationTitle())
            .onAppear {
                if viewModel.jokes.isEmpty {
                    viewModel.fetchJokes()
                }
//                if AppSessionManager.shouldShowAd {
//                    adViewModel.showAd()
//                }
            }
        }
    }
    
}

struct JokeView: View {

    @ObservedObject var notificationManager = GlobalNotificationManager.shared

    let joke: SurvivingJoke
    let mode: JokeListMode

    var body: some View {
        HStack(spacing: 4.0) {
            VStack {
                HStack(spacing: 4.0) {
                    switch mode {
                    case .history:
                        if youHaveContributedToJoke() {
                            Text("🏄‍♂️")
                                .font(Font.system(size: 32.0, weight: .light))
                                .foregroundStyle(.accent)
                                .padding([.bottom], 2.0)
                        }
                        Text("#" + joke.dayRanking.description)
                            .font(Font.system(size: 32.0, weight: .bold))
                            .foregroundStyle(.accent)
                            .padding([.bottom], 2.0)
                        if jokeIsInFavorites() {
                            Text("🩷")
                                .font(Font.system(size: 32.0, weight: .light))
                                .foregroundStyle(.accent)
                                .padding([.bottom], 2.0)
                        }
                    case .lookup:
                        if youHaveContributedToJoke() {
                            Text("🏄‍♂️")
                                .font(Font.system(size: 12.0, weight: .light))
                                .foregroundStyle(.accent)
                                .padding([.bottom], 2.0)
                        }
                        Text("#" + joke.dayRanking.description + " in " + joke.punchLineDisplayName + " on " + joke.dateCreated.displayDate)
                            .font(Font.system(size: 12.0, weight: .bold))
                            .foregroundStyle(.accent)
                            .padding([.bottom], 2.0)
                        if jokeIsInFavorites() {
                            Text("🩷")
                                .font(Font.system(size: 12.0, weight: .light))
                                .foregroundStyle(.accent)
                                .padding([.bottom], 2.0)
                        }
                    }
                }
                HStack {
                    Text(joke.setup)
                        .font(Font.system(size: 20.0, weight: .light))
                    Spacer(minLength: 16.0)
                }
                HStack {
                    Spacer(minLength: 16.0)
                    Text(joke.punchline)
                        .font(Font.system(size: 20.0, weight: .semibold))
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
        .onChange(of: notificationManager.favoritesHaveBeenUpdated) { _, newValue in
            if newValue == true {
                notificationManager.favoritesHaveBeenUpdated = false
                notificationManager.refreshView()
            }
        }
    }

    private func youHaveContributedToJoke() -> Bool {
        guard let currentUserID = AppSessionManager.userInfo?.punchLineUserID else { return false }
        if joke.setupAuthorID == currentUserID || joke.punchlineAuthorID == currentUserID {
            return true
        } else {
            return false
        }
    }

    private func jokeIsInFavorites() -> Bool {
        if (AppSessionManager.userInfo?.favoriteJokes ?? []).contains(where: { favoriteJoke in
            favoriteJoke.originJokeID == self.joke.id
        }) {
            return true
        } else {
            return false
        }
    }

}

#Preview {
    JokeListView(
        viewModel: JokeListViewModel(
            displayDate: MockDataManager.testDateDisplayString,
            jokes: MockDataManager.getMockOrPreviewSurvivingJokeBatch(numberOfJokes: 10),
            mode: .history
        )
    )
}
