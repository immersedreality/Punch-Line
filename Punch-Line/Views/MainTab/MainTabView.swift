//
//  MainTabView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/18/25.
//

import SwiftUI

struct MainTabView: View {

    @StateObject var viewModel = MainViewModel()

    @State private var selection = 1

    var body: some View {
        TabView(selection: $selection) {

            Tab("", systemImage: SystemIcons.jokeHistoryTab, value: 0) {
                JokeHistoryPunchLinesView(
                    viewModel: JokeHistoryPunchLinesViewModel(
                        fetchedPublicPunchLines: viewModel.fetchedPublicPunchLines,
                        fetchedPrivatePunchLines: viewModel.fetchedPrivatePunchLines
                    )
                )
            }

            Tab("", systemImage: SystemIcons.punchLineLaunchersTab, value: 1) {
                PunchLineLaunchersView(
                    viewModel: PunchLineLaunchersViewModel(
                        fetchedPublicPunchLines: viewModel.fetchedPublicPunchLines,
                        fetchedPrivatePunchLines: viewModel.fetchedPrivatePunchLines
                    )
                )
            }

            Tab("", systemImage: SystemIcons.jokeLookupTab, value: 2) {
                JokeLookupView()
            }

        }
        .onChange(of: GlobalNotificationManager.shared.shouldRefreshPunchLines) { _, newValue in
            if newValue == true {
                viewModel.fetchPunchLines()
                GlobalNotificationManager.shared.shouldRefreshPunchLines = false
            }
        }
    }

}

#Preview {
    MainTabView()
}
