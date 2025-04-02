//
//  JokeHistoryView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import SwiftUI

struct JokeHistoryView: View {

    let viewModel = JokeHistoryViewModel()

    @State private var showingModalSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.top])
                List(viewModel.testJokeHistoryEntries) { entry in
                    NavigationLink {
                        JokeListView(viewModel: JokeListViewModel(displayDate: entry.displayDate, jokes: entry.jokes))
                    } label: {
                        JokeHistoryEntryView(displayDate: entry.displayDate)
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
                    Image(systemName: SystemIcons.gear)
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
            .navigationTitle(NavigationTitles.jokeHistory)
        }
    }

}

struct JokeHistoryEntryView: View {

    let displayDate: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(displayDate)
                .font(Font.system(size: 24.0, weight: .bold))
                .foregroundStyle(.accent)
                .padding([.vertical], 16.0)
            Spacer()
        }
    }
}

#Preview {
    JokeHistoryView()
}
