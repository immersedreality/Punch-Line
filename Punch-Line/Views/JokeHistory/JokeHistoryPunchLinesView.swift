//
//  JokeHistoryPunchLinesView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/3/25.
//

import SwiftUI

struct JokeHistoryPunchLinesView: View {

    @State private var showingModalSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.top])
                List(TestDataManager.testPunchLines) { punchLine in
                    PunchLineHistoryView(punchLine: punchLine)
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
    }

}

struct PunchLineHistoryView: View {

    let punchLine: PunchLine

    var body: some View {
        HStack {
            NavigationLink {
                if TestDataManager.testYearCount > 1 {
                    JokeHistoryYearsView(viewModel: JokeHistoryYearsViewModel(punchLineID: punchLine.id))
                } else if TestDataManager.testMonthCount > 1 {
                    JokeHistoryMonthsView(
                        viewModel: JokeHistoryMonthsViewModel(
                            punchLineID: punchLine.id,
                            selectedYear: Calendar.current.component(.year, from: Date())
                        )
                    )
                } else {
                    if let entryGroups = TestDataManager.testJokeHistoryEntryGroups[punchLine.id],
                       let entries = entryGroups.first?.entries {
                        JokeHistoryEntriesView(
                            viewModel: JokeHistoryEntriesViewModel(
                                jokeHistoryEntries: entries
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
                            .padding([.top], 48.0)
                        Text("Best of the Punch-Line")
                            .font(Font.system(size: 24.0, weight: .light))
                            .foregroundStyle(.accent)
                            .padding([.bottom], 48.0)
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
