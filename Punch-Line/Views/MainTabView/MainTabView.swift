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
                if TestDataManager.testYearCount > 1 {
                    JokeHistoryYearsView()
                } else if TestDataManager.testMonthCount > 1 {
                    JokeHistoryMonthsView(
                        viewModel: JokeHistoryMonthsViewModel(
                            selectedYear: Calendar.current.component(.year, from: Date())
                        )
                    )
                } else {
                    if let entries = TestDataManager.testJokeHistoryEntryGroups.first?.entries {
                        JokeHistoryEntriesView(
                            viewModel: JokeHistoryEntriesViewModel(
                                jokeHistoryEntries: entries
                            )
                        )
                    }
                }
            }

        }
    }

}

#Preview {
    MainTabView()
}
