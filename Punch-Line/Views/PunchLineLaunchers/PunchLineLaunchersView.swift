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
                PunchLineLauncherView()
                PunchLineLauncherView()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(ImageTitles.iconNavigationTitle)
                        .foregroundStyle(.accent)
                }
            }
            .navigationTitle("Your Punch-Lines")
            .listRowSpacing(8.0)
        }
    }
}

struct PunchLineLauncherView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Test Title")
                    .font(Font.system(size: 24.0, weight: .bold))
                    .foregroundStyle(.accent)
                    .padding([.top], 48.0)
                Text("Get in the Punch-Line --->")
                    .font(Font.system(size: 24.0, weight: .light))
                    .foregroundStyle(.accent)
                    .padding([.bottom], 48.0)
            }
            Spacer()
        }
        .listRowBackground(StyleManager.generateRandomBackgroundColor())
    }
}

#Preview {
    PunchLineLaunchersView()
}
