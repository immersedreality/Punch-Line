//
//  SettingsView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/1/25.
//

import SwiftUI

struct SettingsView: View {

    @State private var showingExplainerSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.bottom])
                VStack(spacing: 0.0) {
                    Text("Welcome to your settings!  Please enjoy your stay.")
                        .font(Font.system(size: 28.0, weight: .semibold))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 24.0)
                        .padding([.horizontal], 16.0)
                    List {
                        UsernameRow()
                        if AppSessionManager.userInfo?.favoriteJokes.isEmpty == false {
                            FavoriteJokesRow()
                        }
                        if AppSessionManager.userInfo?.ownedPrivatePunchLines.isEmpty == false {
                            OwnedPrivatePunchLinesRow()
                        }
                        if AppSessionManager.userInfo?.joinedPrivatePunchLines.isEmpty == false {
                            JoinedPrivatePunchLinesRow()
                        }
                        ShowOffensiveContentRow()
                        ImNotFunnyModeRow()
                        JerryModeRow()
                        FatFingerModeRow()
                        HStack {
                            Spacer()
                            Button {
                                showingExplainerSheet = true
                            } label: {
                                Image(systemName: SystemIcons.questionMark)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.accent)
                            }
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listRowSpacing(8.0)
                    .scrollContentBackground(.hidden)
                    Spacer()
                }
            }
            .toolbarVisibility(.hidden)
            .navigationTitle("Settings")
            .sheet(isPresented: $showingExplainerSheet) {
                ExplainerView(mode: .reexplain)
                    .presentationDragIndicator(.visible)
            }
        }
    }

}

struct FavoriteJokesRow: View {

    var body: some View {
        NavigationLink {
            FavoriteJokeListView()
        } label: {
            Text("Favorited Jokes")
                .font(Font.system(size: 20.0, weight: .light))
                .foregroundStyle(.accent)
        }
    }

}

struct OwnedPrivatePunchLinesRow: View {

    var body: some View {
        NavigationLink {
            PrivatePunchLinesListView(viewModel: PrivatePunchLinesListViewModel(mode: .owned))
        } label: {
            Text("Owned Private Punch-Lines")
                .font(Font.system(size: 20.0, weight: .light))
                .foregroundStyle(.accent)
        }
    }

}

struct JoinedPrivatePunchLinesRow: View {

    var body: some View {
        NavigationLink {
            PrivatePunchLinesListView(viewModel: PrivatePunchLinesListViewModel(mode: .joined))
        } label: {
            Text("Joined Private Punch-Lines")
                .font(Font.system(size: 20.0, weight: .light))
                .foregroundStyle(.accent)
        }
    }

}

struct ShowOffensiveContentRow: View {

    @State private var shouldSeeOffensiveContent = AppSessionManager.userInfo?.shouldSeeOffensiveContent ?? false

    var body: some View {
        VStack {
            HStack {
                Text("Show All Content?")
                    .font(Font.system(size: 20.0, weight: .light))
                    .foregroundStyle(.accent)
                Spacer()
                Toggle(isOn: $shouldSeeOffensiveContent) { }
                    .onChange(of: shouldSeeOffensiveContent) { _, _ in
                        AppSessionManager.toggleShouldSeeOffensiveContent()
                    }
            }
            HStack {
                Text("When 'Show All Content' is enabled you will see unvetted content and content flagged as offensive.")
                    .font(Font.system(size: 12.0, weight: .light))
                    .foregroundStyle(.gray)
                Spacer()
            }
        }
    }

}

struct ImNotFunnyModeRow: View {

    @ObservedObject var notificationManager = GlobalNotificationManager.shared
    @State private var userIsNotFunny = AppSessionManager.userInfo?.userIsNotFunny ?? false

    var body: some View {
        VStack {
            HStack {
                Text("I'm Not Funny Mode")
                    .font(Font.system(size: 20.0, weight: .light))
                    .foregroundStyle(.accent)
                Spacer()
                Toggle(isOn: $userIsNotFunny) { }
                    .onChange(of: userIsNotFunny) { _, newValue in
                        AppSessionManager.setUserIsNotFunny(to: newValue)
                    }
            }
            HStack {
                Text("When 'I'm Not Funny Mode' is enabled you will only be tasked with setups and votes, never punchlines.")
                    .font(Font.system(size: 12.0, weight: .light))
                    .foregroundStyle(.gray)
                Spacer()
            }
        }
        .onChange(of: notificationManager.appModesHaveChanged) { _, newValue in
            if newValue == true {
                notificationManager.appModesHaveChanged = false
                userIsNotFunny = AppSessionManager.userInfo?.userIsNotFunny ?? false
            }
        }
    }

}

struct JerryModeRow: View {

    @ObservedObject var notificationManager = GlobalNotificationManager.shared
    @State private var usersNameIsJerry = AppSessionManager.userInfo?.usersNameIsJerry ?? false

    var body: some View {
        VStack {
            HStack {
                Text("Jerry Mode")
                    .font(Font.system(size: 20.0, weight: .light))
                    .foregroundStyle(.accent)
                Spacer()
                Toggle(isOn: $usersNameIsJerry) { }
                    .onChange(of: usersNameIsJerry) { _, newValue in
                        AppSessionManager.setUsersNameIsJerry(to: newValue)
                    }
            }
            HStack {
                Text("When 'Jerry Mode' is enabled you will primarily be tasked with punchlines and votes, rarely setups.")
                    .font(Font.system(size: 12.0, weight: .light))
                    .foregroundStyle(.gray)
                Spacer()
            }
        }
        .onChange(of: notificationManager.appModesHaveChanged) { _, newValue in
            if newValue == true {
                notificationManager.appModesHaveChanged = false
                usersNameIsJerry = AppSessionManager.userInfo?.usersNameIsJerry ?? false
            }
        }
    }

}

struct FatFingerModeRow: View {

    @State private var userHasFatFingers = AppSessionManager.userInfo?.userHasFatFingers ?? false

    var body: some View {
        VStack {
            HStack {
                Text("Fat Fingers Mode")
                    .font(Font.system(size: 20.0, weight: .light))
                    .foregroundStyle(.accent)
                Spacer()
                Toggle(isOn: $userHasFatFingers) { }
                    .onChange(of: userHasFatFingers) { _, _ in
                        AppSessionManager.toggleUserHasFatFingers()
                    }
            }
            HStack {
                Text("When 'Fat Fingers Mode' is enabled you will be prompted to confirm your submissions.")
                    .font(Font.system(size: 12.0, weight: .light))
                    .foregroundStyle(.gray)
                Spacer()
            }
        }
    }

}

struct UsernameRow: View {

    @State private var enteredUsernameText: String = AppSessionManager.userInfo?.punchLineUsername ?? ""
    @State private var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""

    var body: some View {
        TextField("Enter A Username If You'd Like", text: $enteredUsernameText)
            .textFieldStyle(.plain)
            .font(Font.system(size: 20.0, weight: .semibold))
            .foregroundStyle(.accent)
            .submitLabel(.done)
            .onSubmit({
                validateTextEntry()
            })
            .alert(alertTitle, isPresented: $showingAlert) {
                Button(AlertConstants.okeydoke) {
                }
            } message: {
                Text(alertMessage)
            }
    }

    private func validateTextEntry() {
        guard enteredUsernameText.count >= 3 else {
            enteredUsernameText = AppSessionManager.userInfo?.punchLineUsername ?? ""
            alertTitle = "Invalid Name"
            alertMessage = "Names must be a minimum of 3 characters."
            showingAlert = true
            return
        }

        guard enteredUsernameText.count <= 30 else {
            enteredUsernameText = AppSessionManager.userInfo?.punchLineUsername ?? ""
            alertTitle = "Invalid Name"
            alertMessage = "Names must be 30 characters or less."
            showingAlert = true
            return
        }

        guard !enteredUsernameText.containsBannedWords() else {
            enteredUsernameText = AppSessionManager.userInfo?.punchLineUsername ?? ""
            alertTitle = "Invalid Name"
            alertMessage = "Names may not contain offensive words."
            showingAlert = true
            return
        }

        AppSessionManager.set(username: enteredUsernameText)
        alertTitle = "Name Updated"
        alertMessage = "Your author name has been successfully updated!"
        showingAlert = true
    }

}

#Preview {
    SettingsView()
}
