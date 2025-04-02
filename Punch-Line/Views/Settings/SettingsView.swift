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
                        if AppSessionManager.userInfo?.favoriteJokes.isEmpty == false {
                            FavoriteJokesRow()
                        }
                        ShowOffensiveContentRow()
                        GetPunchLineProRow()
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

struct ShowOffensiveContentRow: View {

    @State private var shouldSeeOffensiveContent = AppSessionManager.userInfo?.shouldSeeOffensiveContent ?? false

    var body: some View {
        HStack {
            Text("Show Offensive Content?")
                .font(Font.system(size: 20.0, weight: .light))
                .foregroundStyle(.accent)
            Spacer()
            Toggle(isOn: $shouldSeeOffensiveContent) { }
        }
    }

}

struct GetPunchLineProRow: View {

    @State private var showingAlert = false

    var body: some View {
        Text("Get PunchLine Pro!  Get Rid of Ads! Get Credit for Your Fantastic Joke Contributions!")
            .font(Font.system(size: 20.0, weight: .light))
            .foregroundStyle(.accent)
            .onTapGesture {
                showingAlert = true
            }
            .alert("Coming Soon!", isPresented: $showingAlert) {
                Button("Okeydoke") {
                }
            } message: {
                Text("This service is not yet available.")
            }
    }

}

#Preview {
    SettingsView()
}
