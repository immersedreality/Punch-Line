//
//  MainTabView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/18/25.
//

import SwiftUI

struct MainTabView: View {

    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var notificationManager = GlobalNotificationManager.shared
    @StateObject var viewModel = MainViewModel()
    @State private var selection = 1

    @State private var showingExplainerSheet = false
    
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
        .onAppear {
            if AppSessionManager.userInfo?.userHasSeenExplainer == false {
                AppSessionManager.toggleUserHasSeenExplainer()
                showingExplainerSheet = true
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.fetchPunchLines()
            } else if newPhase == .inactive {
                selection = 1
            }
        }
        .onChange(of: notificationManager.shouldRefreshPunchLines) { _, newValue in
            if newValue == true {
                viewModel.fetchPunchLines()
                notificationManager.shouldRefreshPunchLines = false
            }
        }
        .sheet(isPresented: $showingExplainerSheet) {
            ExplainerView()
                .presentationDragIndicator(.visible)
        }
    }

}

#Preview {
    MainTabView()
}
