//
//  JokeHistoryView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import SwiftUI

struct JokeHistoryView: View {

    let viewModel = JokeHistoryViewModel()

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
                .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                .padding([.vertical], 16.0)
            Spacer()
        }
    }
}

#Preview {
    JokeHistoryView()
}
