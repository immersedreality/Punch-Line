//
//  PunchLineLaunchersView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import SwiftUI

struct PunchLineLaunchersView: View {

    let viewModel = PunchLineLaunchersViewModel()

    @StateObject private var localDataManager = LocalDataManager.shared
    @State private var showingPunchLineSheet = false
    @State private var showingSettingsSheet = false

    var body: some View {
        NavigationStack {
            List(localDataManager.fetchedPublicPunchLines) { punchLine in
                PunchLineLauncherView(punchLine: punchLine)
                    .onTapGesture {
                        viewModel.selectedPunchLine = punchLine
                        showingPunchLineSheet = true
                    }
            }
            .sheet(isPresented: $showingPunchLineSheet) {
                if let punchLine = viewModel.selectedPunchLine {
                    PunchLineActivityRootView(
                        viewModel: PunchLineActivityViewModel(
                            punchLine: punchLine,
                            activity: viewModel.getInitialPunchLineActivity(),
                            activityDisplayText: viewModel.getInitialPunchLineActivityDisplayText()
                        )
                    )
                    .presentationDragIndicator(.visible)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(ImageTitles.iconNavigationTitle)
                        .foregroundStyle(.accent)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: SystemIcons.settingsButton)
                        .foregroundStyle(.accent)
                        .onTapGesture {
                            showingSettingsSheet = true
                        }
                        .sheet(isPresented: $showingSettingsSheet) {
                            SettingsView()
                                .presentationDragIndicator(.visible)
                        }
                }
            }
            .navigationTitle(NavigationTitles.punchLineLaunchers)
            .listRowSpacing(8.0)
        }
    }
    
}

struct PunchLineLauncherView: View {

    let punchLine: PunchLine

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(punchLine.displayName)
                    .font(Font.system(size: 24.0, weight: .bold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 48.0)
                Text("Get in the Punch-Line --->")
                    .font(Font.system(size: 24.0, weight: .light))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
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
