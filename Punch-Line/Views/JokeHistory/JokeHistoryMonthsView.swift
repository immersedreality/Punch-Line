//
//  JokeHistoryMonthsView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/2/25.
//

import SwiftUI

struct JokeHistoryMonthsView: View {

    @StateObject var viewModel: JokeHistoryMonthsViewModel
    
    @State private var showingModalSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.jokeHistoryMonthsBackgroundColor
                    .ignoresSafeArea(edges: [.top])
                List(viewModel.getRowData()) { rowData in
                    NavigationLink {
                        let selectedEntries = viewModel.getSelectedJokeHistoryEntries(selectedMonth: rowData.entryGroup.month)
                        JokeHistoryEntriesView(
                            viewModel: JokeHistoryEntriesViewModel(
                                jokeHistoryEntries: selectedEntries,
                                entryGroup: rowData.entryGroup
                            )
                        )
                    } label: {
                        JokeHistoryRowView(rowTitle: rowData.entryGroup.displayMonth)
                    }
                    .disabled(viewModel.entriesDictionary.isEmpty)
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
        .onAppear {
            viewModel.fetchEntriesForEntryGroups()
        }
    }

}

#Preview {
    JokeHistoryMonthsView(
        viewModel: JokeHistoryMonthsViewModel(
            punchLineID: UUID().uuidString,
            selectedYear: 2025,
            entryGroups: MockDataManager.getPreviewJokeHistoryEntryGroups()
        )
    )
}
