//
//  MainTabView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/18/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("", systemImage: SystemIcons.punchLineLaunchersTab) {
                PunchLineLaunchersView()
            }

            Tab("", systemImage: SystemIcons.jokeHistoryTab) {
                JokeHistoryView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
