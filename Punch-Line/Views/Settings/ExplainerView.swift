//
//  ExplainerView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 5/23/25.
//

import SwiftUI

struct ExplainerView: View {

    @Environment(\.dismiss) var dismiss

    let mode: ExplainerViewMode

    var body: some View {
        ZStack {
            StyleManager.generateRandomBackgroundColor()
                .ignoresSafeArea(edges: [.bottom])
            VStack(alignment: .leading, spacing: 0.0) {
                Text("The Punch-Line Explainer.  Learn To Be Funny.")
                    .font(Font.system(size: 28.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 20.0)
                    .padding([.horizontal], 16.0)
                Text("1. What is a Punch-Line?")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 8.0)
                    .padding([.horizontal], 16.0)
                Text("A joke-writing group that everyone contributes to!")
                    .font(Font.system(size: 16.0, weight: .regular))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 4.0)
                    .padding([.horizontal], 16.0)
                List {
                    DummyPunchLineLauncherView()
                }
                .scrollDisabled(true)
                .contentMargins([.vertical], 8.0)
                .scrollContentBackground(.hidden)
                .frame(maxHeight: 88)
                Text("2. What will it ask me to do?")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 8.0)
                    .padding([.horizontal], 16.0)
                Text("Submit setups, punchlines, and vote on jokes!")
                    .font(Font.system(size: 16.0, weight: .regular))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 4.0)
                    .padding([.horizontal], 16.0)
                List {
                    DummyJokeView()
                }
                .scrollDisabled(true)
                .contentMargins([.vertical], 8.0)
                .scrollContentBackground(.hidden)
                .frame(maxHeight: 80)
                if mode == .explain {
                    Text("Tweak your options before getting started!")
                        .font(Font.system(size: 16.0, weight: .regular))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 4.0)
                        .padding([.horizontal], 16.0)
                    List {
                        UsernameRow()
                        ShowOffensiveContentView()
                    }
                    .scrollDisabled(true)
                    .contentMargins([.vertical], 8.0)
                    .listRowSpacing(8.0)
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: 108)
                    Text("There are more on the settings page!")
                        .font(Font.system(size: 16.0, weight: .regular))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 4.0)
                        .padding([.horizontal], 16.0)
                }
                Text("3. I did a bunch of stuff.  Now what?")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 8.0)
                    .padding([.horizontal], 16.0)
                Text("Check back the next day for the joke rankings!")
                    .font(Font.system(size: 16.0, weight: .regular))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 4.0)
                    .padding([.horizontal], 16.0)
                if mode == .explain {
                    Button {
                        AppSessionManager.userIsInTraining = true
                        GlobalNotificationManager.shared.shouldLaunchTrainingMode = true
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Get In A Punch-Line! --->")
                                .padding([.vertical], 8.0)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.white)
                    .backgroundStyle(.accent)
                    .padding([.top], 8.0)
                    .padding([.horizontal], 16.0)
                }
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
        }
    }

}

struct DummyPunchLineLauncherView: View {

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("They Look Like This")
                    .font(Font.system(size: 24.0, weight: .bold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 0.0)
                Text("Get In One! --->")
                    .font(Font.system(size: 24.0, weight: .light))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.bottom], 0.0)
            }
            Spacer()
        }
    }

}

struct DummyJokeView: View {

    var body: some View {
        HStack(spacing: 4.0) {
            VStack {
                HStack {
                    Text("Setups start off jokes...")
                        .font(Font.system(size: 20.0, weight: .light))
                    Spacer(minLength: 16.0)
                }
                HStack {
                    Spacer(minLength: 16.0)
                    Text("...and punchlines finish them!")
                        .font(Font.system(size: 20.0, weight: .semibold))
                }
            }
        }
    }

}

struct ShowOffensiveContentView: View {

    @State private var shouldSeeOffensiveContent = AppSessionManager.userInfo?.shouldSeeOffensiveContent ?? false

    var body: some View {
        VStack {
            HStack {
                Text("Edgy Content Okay?")
                    .font(Font.system(size: 20.0, weight: .light))
                    .foregroundStyle(.accent)
                Spacer()
                Toggle(isOn: $shouldSeeOffensiveContent) { }
                    .onChange(of: shouldSeeOffensiveContent) { _, _ in
                        AppSessionManager.toggleShouldSeeOffensiveContent()
                    }
            }
        }
    }

}

enum ExplainerViewMode {
    case explain, reexplain
}

#Preview {
    ExplainerView(mode: .explain)
}
