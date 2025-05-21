//
//  MainViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/19/25.
//

import Foundation

class MainViewModel: ObservableObject {

    @Published private(set) var fetchedPublicPunchLines: [PublicPunchLine] = []
    @Published private(set) var fetchedPrivatePunchLines: [PrivatePunchLine] = []

    func fetchPunchLines() {
        guard let userInfo = AppSessionManager.userInfo else { return }

        var privatePunchLineIDs: [String] = []
        userInfo.ownedPrivatePunchLines.forEach { privatePunchLineIDs.append($0.id) }
        userInfo.joinedPrivatePunchLines.forEach { privatePunchLineIDs.append($0.id) }

        Task {
            await self.fetchedPublicPunchLines = APIManager.getPublicPunchLines()
            await self.fetchedPrivatePunchLines = APIManager.getPrivatePunchLines(with: privatePunchLineIDs)
        }
    }

}
