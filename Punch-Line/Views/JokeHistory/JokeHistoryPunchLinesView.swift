//
//  JokeHistoryPunchLinesView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/3/25.
//

import SwiftUI

struct JokeHistoryPunchLinesView: View {

    let viewModel = JokeHistoryPunchLinesViewModel()

    @StateObject private var localDataManager = LocalDataManager.shared
    @State private var showingModalSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.top])
                List(localDataManager.fetchedPublicPunchLines) { punchLine in
                    PunchLineHistoryView(viewModel: viewModel, punchLine: punchLine)
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
                                showingModalSheet = true
                            }
                            .sheet(isPresented: $showingModalSheet) {
                                SettingsView()
                                    .presentationDragIndicator(.visible)
                            }
                    }
                }
                .navigationTitle(NavigationTitles.jokeHistoryPunchLines)
                .listRowSpacing(8.0)
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear {
            viewModel.fetchJokeHistoryEntryGroups()
        }
    }

}

struct PunchLineHistoryView: View {

    let viewModel: JokeHistoryPunchLinesViewModel
    let punchLine: PunchLine

    var body: some View {
        HStack {
            NavigationLink {
                if viewModel.entryGroupsYearCount(for: punchLine.id) > 1 {
                    JokeHistoryYearsView(
                        viewModel: JokeHistoryYearsViewModel(
                            punchLineID: punchLine.id,
                            entryGroups: viewModel.getSelectedJokeHistoryEntryGroups(for: punchLine.id)
                        )
                    )
                } else if viewModel.entryGroupsMonthCount(for: punchLine.id) > 1 {
                    JokeHistoryMonthsView(
                        viewModel: JokeHistoryMonthsViewModel(
                            punchLineID: punchLine.id,
                            selectedYear: Calendar.current.component(.year, from: Date()),
                            entryGroups: viewModel.getSelectedJokeHistoryEntryGroups(for: punchLine.id)
                        )
                    )
                } else {
                    if let entryGroup = viewModel.getSelectedJokeHistoryEntryGroups(for: punchLine.id).first {
                        JokeHistoryEntriesView(
                            viewModel: JokeHistoryEntriesViewModel(
                                jokeHistoryEntryGroup: entryGroup
                            )
                        )
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    VStack {
                        Text(punchLine.displayName)
                            .font(Font.system(size: 24.0, weight: .bold))
                            .foregroundStyle(.accent)
                            .padding([.top], 16.0)
                        Text("Best of the Punch-Line")
                            .font(Font.system(size: 24.0, weight: .light))
                            .foregroundStyle(.accent)
                            .padding([.bottom], 16.0)
                    }
                    Spacer()
                }
            }
        }
    }

}

#Preview {
    JokeHistoryPunchLinesView()
}
