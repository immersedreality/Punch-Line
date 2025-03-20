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
            Tab("", systemImage: TabBarIcons.punchLineLaunchersTab) {

            }

            Tab("", systemImage: TabBarIcons.jokeVaultTab) {

            }
        }
    }
}

#Preview {
    MainTabView()
}
