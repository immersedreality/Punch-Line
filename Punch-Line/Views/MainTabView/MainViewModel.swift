//
//  MainViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/19/25.
//

import Foundation

class MainViewModel: ObservableObject {

    @Published private(set) var fetchedPublicPunchLines: [PunchLine] = []

    init() {
        fetchPublicPunchLines()
    }

    func fetchPublicPunchLines() {
        Task {
            await self.fetchedPublicPunchLines = APIManager.getPublicPunchLines()
        }
    }

}
