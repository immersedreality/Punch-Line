//
//  PunchLineLaunchersView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import SwiftUI

struct PunchLineLaunchersView: View {
    var body: some View {
        NavigationStack {
            List {
                PunchLineLauncherView()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(ImageTitles.iconNavigationTitle)
                        .foregroundStyle(.accent)
                }
            }
            .navigationTitle(NavigationTitles.punchLineLaunchers)
            .listRowSpacing(8.0)
        }
    }
}

struct PunchLineLauncherView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
//                Text("Punch-Line Title")
//                    .font(Font.system(size: 24.0, weight: .bold))
//                    .foregroundStyle(.accent)
//                    .padding([.top], 48.0)
                Text("Get in the Punch-Line --->")
                    .font(Font.system(size: 24.0, weight: .light))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.vertical], 48.0)
            }
            Spacer()
        }
        .listRowBackground(StyleManager.generateRandomBackgroundColor())
    }
}

#Preview {
    PunchLineLaunchersView()
}
