//
//  SettingsView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/1/25.
//

import SwiftUI

struct SettingsView: View {

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
                        if AppSessionManager.userInfo?.hasPunchLinePro == true {
                            UserNameRow()
                        }
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
                        if AppSessionManager.userInfo?.hasPunchLinePro == false {
                            GetPunchLineProRow()
                        }
                    }
                    .listRowSpacing(8.0)
                    .scrollContentBackground(.hidden)
                    Spacer()
                }
            }
            .toolbarVisibility(.hidden)
            .navigationTitle("Settings")
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
        HStack {
            Text("Show Offensive Content?")
                .font(Font.system(size: 20.0, weight: .light))
                .foregroundStyle(.accent)
            Spacer()
            Toggle(isOn: $shouldSeeOffensiveContent) { }
                .onChange(of: shouldSeeOffensiveContent) { _, _ in
                    AppSessionManager.toggleOffensiveContentFilter()
                }
        }
    }

}

struct UserNameRow: View {

    @State private var enteredUserNameText: String = AppSessionManager.userInfo?.punchLineUserName ?? ""
    @State private var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""

    var body: some View {
        TextField("Enter Your Name Here", text: $enteredUserNameText)
            .textFieldStyle(.plain)
            .font(Font.system(size: 20.0, weight: .semibold))
            .foregroundStyle(.accent)
            .submitLabel(.done)
            .onSubmit({
                validateTextEntry()
            })
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("Okeydoke") {
                }
            } message: {
                Text(alertMessage)
            }
    }

    private func validateTextEntry() {
        guard enteredUserNameText.count >= 8 else {
            enteredUserNameText = AppSessionManager.userInfo?.punchLineUserName ?? ""
            alertTitle = "Invalid Name"
            alertMessage = "Names must be a minimum of 8 characters."
            showingAlert = true
            return
        }

        guard enteredUserNameText.count <= 32 else {
            enteredUserNameText = AppSessionManager.userInfo?.punchLineUserName ?? ""
            alertTitle = "Invalid Name"
            alertMessage = "Names must be 32 characters or less."
            showingAlert = true
            return
        }

        guard !enteredUserNameText.containsBannedWords() else {
            enteredUserNameText = AppSessionManager.userInfo?.punchLineUserName ?? ""
            alertTitle = "Invalid Name"
            alertMessage = "Names may not contain offensive words."
            showingAlert = true
            return
        }

        AppSessionManager.set(userName: enteredUserNameText)
        alertTitle = "Name Updated"
        alertMessage = "Your author name has been successfully updated!"
        showingAlert = true
    }

}

struct GetPunchLineProRow: View {

    @State private var showingAlert = false

    var body: some View {
        Text("Get PunchLine Pro!  Why?!\n1. Get Rid Of Ads!\n2. Authorship Over Your Fantastic Joke Contributions!! \n3. Create And Share Your Own Private Punch-Lines!!!")
            .font(Font.system(size: 20.0, weight: .light))
            .foregroundStyle(.accent)
            .onTapGesture {
                showingAlert = true
            }
            .alert("Coming Soon!", isPresented: $showingAlert) {
                Button("Okeydoke") {
                }
            } message: {
                Text("This service is not yet available.  Be patient, you little freak!")
            }
    }

}

#Preview {
    SettingsView()
}
