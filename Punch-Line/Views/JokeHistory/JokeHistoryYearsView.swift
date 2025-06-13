//
//  JokeHistoryYearsView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/2/25.
//

import SwiftUI

struct JokeHistoryYearsView: View {

    let viewModel: JokeHistoryYearsViewModel
    
    @State private var showingModalSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.jokeHistoryYearsBackgroundColor
                    .ignoresSafeArea(edges: [.top])
                List(viewModel.getRowData()) { rowData in
                    NavigationLink {
                        JokeHistoryMonthsView(
                            viewModel: JokeHistoryMonthsViewModel(
                                punchLineID: viewModel.punchLineID,
                                selectedYear: rowData.entryGroup.year,
                                entryGroups: viewModel.entryGroups
                            )
                        )
                    } label: {
                        JokeHistoryRowView(rowTitle: rowData.entryGroup.year.description)
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
            .navigationTitle(NavigationTitles.jokeHistoryYears)
        }
    }

}

#Preview {
    JokeHistoryYearsView(
        viewModel: JokeHistoryYearsViewModel(
            punchLineID: UUID().uuidString,
            entryGroups: MockDataManager.getPreviewJokeHistoryEntryGroups()
        )
    )
}
