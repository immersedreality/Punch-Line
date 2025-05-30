//
//  ExplainerView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 5/23/25.
//

import SwiftUI

struct ExplainerView: View {

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
                Text("1. What is a Punch-Line anyway?")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 12.0)
                    .padding([.horizontal], 16.0)
                Text("A Punch-Line is a joke writing group that automatically assigns tasks to each member.")
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
                .frame(maxHeight: 104)
                Text("2. Who can join a Punch-Line?")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 12.0)
                    .padding([.horizontal], 16.0)
                Text("Public Punch-Lines are for everyone. You can also create Private Punch-Lines for just your friends!")
                    .font(Font.system(size: 16.0, weight: .regular))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 4.0)
                    .padding([.horizontal], 16.0)
                if mode == .explain {
                    Text("3. I want writing credit and more (potentially offensive) content!")
                        .font(Font.system(size: 20.0, weight: .semibold))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 12.0)
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
                    Text("There are more options on the settings page!")
                        .font(Font.system(size: 16.0, weight: .regular))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 4.0)
                        .padding([.horizontal], 16.0)
                    Text("4. Where do our jokes go?")
                        .font(Font.system(size: 20.0, weight: .semibold))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 12.0)
                        .padding([.horizontal], 16.0)
                    Text("At midnight (America/New_York) every night, the top-rated jokes are sorted into a ranked list and saved.  All other jokes are deleted forever.  Sorry!")
                        .font(Font.system(size: 16.0, weight: .regular))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 4.0)
                        .padding([.horizontal], 16.0)
                } else {
                    Text("3. Where do our jokes go?")
                        .font(Font.system(size: 20.0, weight: .semibold))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 12.0)
                        .padding([.horizontal], 16.0)
                    Text("At midnight (America/New_York) every night, the top-rated jokes are sorted into a ranked list and saved.  All other jokes are deleted forever.  Sorry!")
                        .font(Font.system(size: 16.0, weight: .regular))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 4.0)
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
                    .padding([.top], 8.0)
                Text("Get In One, Bro! --->")
                    .font(Font.system(size: 24.0, weight: .light))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.bottom], 8.0)
            }
            Spacer()
        }
    }

}

struct ShowOffensiveContentView: View {

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
        }
    }

}

enum ExplainerViewMode {
    case explain, reexplain
}

#Preview {
    ExplainerView(mode: .explain)
}
