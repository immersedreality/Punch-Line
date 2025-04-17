//
//  JokeLookupViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/16/25.
//

import Foundation

class JokeLookupViewModel: ObservableObject {
    
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty { searchResults = [] }
        }
    }
    @Published var debouncedSearchText: String = ""
    @Published var searchResults: [Joke] = []

    init() {
        configureDebounce()
    }

    private func configureDebounce() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .assign(to: &$debouncedSearchText)
    }

    func fetchSearchResults() {
        guard debouncedSearchText.count > 2 else { return }
        DispatchQueue.main.async {
            Task {
                self.searchResults = await APIManager.getSearchResults(for: self.debouncedSearchText)
            }
        }
    }

}
