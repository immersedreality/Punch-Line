//
//  MainTabView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/18/25.
//

import SwiftUI

struct MainTabView: View {

    @State private var selection = 1

    var body: some View {
        TabView(selection: $selection) {

            Tab("", systemImage: SystemIcons.jokeHistoryTab, value: 0) {
                JokeHistoryPunchLinesView()
            }

            Tab("", systemImage: SystemIcons.punchLineLaunchersTab, value: 1) {
                PunchLineLaunchersView()
            }

            Tab("", systemImage: SystemIcons.jokeLookupTab, value: 2) {
                JokeLookupView()
            }

        }
    }

}

#Preview {
    MainTabView()
}
