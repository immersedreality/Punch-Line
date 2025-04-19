//
//  JokeLookupView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct JokeLookupView: View {

    @StateObject var viewModel = JokeLookupViewModel()
    let adViewModel = InterstitialAdViewModel()
    
    @State private var showingModalSheet = false
    @FocusState private var searchFieldIsFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.jokeLookupBackgroundColor
                    .ignoresSafeArea(edges: [.top])
                if viewModel.searchResults.isEmpty {
                    Text("There is currently nothing funny for me to show you. Perhaps you should try searching for something that could give you a little tickle. - Jeff")
                        .font(Font.system(size: 24.0, weight: .bold))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.horizontal], 16.0)
                } else {
                    JokeListView(
                        viewModel: JokeListViewModel(
                            displayDate: "",
                            jokes: viewModel.searchResults,
                            mode: .lookup
                        )
                    )
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
                            showingModalSheet = true
                        }
                        .sheet(isPresented: $showingModalSheet) {
                            SettingsView()
                                .presentationDragIndicator(.visible)
                        }
                }
            }
            .navigationTitle(NavigationTitles.jokeLookup)
        }
        .searchable(text: $viewModel.searchText)
        .searchFocused($searchFieldIsFocused)
        .onAppear {
            searchFieldIsFocused = true
        }
        .onChange(of: viewModel.debouncedSearchText) { _, _ in
            viewModel.fetchSearchResults()
            if AppSessionManager.shouldShowAd {
                adViewModel.showAd()
            }
        }
    }

}

#Preview {
    JokeLookupView()
}
