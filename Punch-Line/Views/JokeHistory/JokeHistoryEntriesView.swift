//
//  JokeHistoryEntriesView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import SwiftUI

struct JokeHistoryEntriesView: View {

    let viewModel: JokeHistoryEntriesViewModel
    
    init(viewModel: JokeHistoryEntriesViewModel) {
        self.viewModel = viewModel
    }

    @State private var showingModalSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.top])
                List(viewModel.jokeHistoryEntries) { entry in
                    NavigationLink {
                        JokeListView(
                            viewModel: JokeListViewModel(
                                displayDate: entry.date.displayDate,
                                entryID: entry.id,
                                mode: .history
                            )
                        )
                    } label: {
                        JokeHistoryRowView(rowTitle: entry.date.displayDate)
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
            .navigationTitle(NavigationTitles.jokeHistoryEntries)
        }
    }

}

#Preview {
    JokeHistoryEntriesView(
        viewModel: JokeHistoryEntriesViewModel(
            jokeHistoryEntries: MockDataManager.getPreviewJokeHistoryEntries()
        )
    )
}
