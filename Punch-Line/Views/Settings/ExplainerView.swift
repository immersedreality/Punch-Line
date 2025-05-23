//
//  ExplainerView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 5/23/25.
//

import SwiftUI

struct ExplainerView: View {

    var body: some View {
        ZStack {
            StyleManager.generateRandomBackgroundColor()
                .ignoresSafeArea(edges: [.bottom])
            VStack(alignment: .leading, spacing: 0.0) {
                Text("The Punch-Line Explainer.  Learn To Be Funny.")
                    .font(Font.system(size: 28.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 24.0)
                    .padding([.horizontal], 16.0)
                Text("1. What is a Punch-Line anyway?")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 16.0)
                    .padding([.horizontal], 16.0)
                List {
                    DummyPunchLineLauncherView()
                }
                .contentMargins([.vertical], 8.0)
                .scrollContentBackground(.hidden)
                .frame(maxHeight: 120)
                Text("A Punch-Line is a collaborative joke writing group that automatically assigns each contributor unique tasks.")
                    .font(Font.system(size: 16.0, weight: .regular))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 4.0)
                    .padding([.horizontal], 16.0)
                Text("2. Who can join a Punch-Line?")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 16.0)
                    .padding([.horizontal], 16.0)
                Text("Public Punch-Lines are available to all users. You can also create Private Punch-Lines for just your friends.  Figure out how, I believe in you! - Jeff")
                    .font(Font.system(size: 16.0, weight: .regular))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 4.0)
                    .padding([.horizontal], 16.0)
                Text("3. Where do our jokes go?")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 16.0)
                    .padding([.horizontal], 16.0)
                Text("At midnight (America/New_York) every night, the top-rated jokes are sorted into a ranked list and saved.  All other jokes are deleted forever.  Sorry!")
                    .font(Font.system(size: 16.0, weight: .regular))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 4.0)
                    .padding([.horizontal], 16.0)
                Text("4. How do I get writing credit?")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 16.0)
                    .padding([.horizontal], 16.0)
                Text("Enter a username on the settings page, my man!  You can also elect to stay anonymous, of course.")
                    .font(Font.system(size: 16.0, weight: .regular))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 4.0)
                    .padding([.horizontal], 16.0)
                Text("5. Damn, I’m not funny at all and I suck at typing!  Also, I like being offended!")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 16.0)
                    .padding([.horizontal], 16.0)
                Text("Check out the other options on the settings page!")
                    .font(Font.system(size: 16.0, weight: .regular))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 4.0)
                    .padding([.horizontal], 16.0)
                Spacer()
            }
        }
    }

}

struct DummyPunchLineLauncherView: View {

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("This Is a Punch-Line")
                    .font(Font.system(size: 24.0, weight: .bold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 16.0)
                Text("Get In It, Bro! --->")
                    .font(Font.system(size: 24.0, weight: .light))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.bottom], 16.0)
            }
            Spacer()
        }
    }

}

#Preview {
    ExplainerView()
}
