//
//  JokeHistoryMonthsView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/2/25.
//

import SwiftUI

struct JokeHistoryMonthsView: View {

    let viewModel: JokeHistoryMonthsViewModel

    init(viewModel: JokeHistoryMonthsViewModel) {
        self.viewModel = viewModel
    }

    @State private var showingModalSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.top])
                List(viewModel.getRowData()) { rowData in
                    NavigationLink {
                        JokeHistoryEntriesView(
                            viewModel: JokeHistoryEntriesViewModel(
                                jokeHistoryEntries: viewModel.getSelectedJokeHistoryEntries(
                                    for: viewModel.punchLineID,
                                    selectedMonth: rowData.rowValue
                                )
                            )
                        )
                    } label: {
                        JokeHistoryRowView(rowTitle: rowData.rowTitle)
                    }
                }
                .listRowSpacing(8.0)
                .scrollContentBackground(.hidden)
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
            .navigationTitle(NavigationTitles.jokeHistoryMonths)
        }
    }

}

#Preview {
    JokeHistoryMonthsView(
        viewModel: JokeHistoryMonthsViewModel(punchLineID: UUID().uuidString, selectedYear: 2025)
    )
}
