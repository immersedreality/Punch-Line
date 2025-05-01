//
//  PrivatePunchLinesListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import Foundation

class PrivatePunchLinesListViewModel: ObservableObject {

    let mode: PrivatePunchLinesListViewMode

    var navigationTitle: String {
        switch mode {
        case .owned:
            return NavigationTitles.ownedPrivatePunchLines
        case .joined:
            return NavigationTitles.joinedPrivatePunchLines
        }
    }
    
    var privatePunchLines: [PrivatePunchLine] {
        switch mode {
        case .owned:
            return AppSessionManager.userInfo?.ownedPrivatePunchLines ?? []
        case .joined:
            return AppSessionManager.userInfo?.joinedPrivatePunchLines ?? []
        }
    }

    private var selectedPrivatePunchLineID: String?

    @Published var shouldNavigateBackToSettings = false

    init(mode: PrivatePunchLinesListViewMode) {
        self.mode = mode
    }

    func set(selectedPrivatePunchLineID: String) {
        self.selectedPrivatePunchLineID = selectedPrivatePunchLineID
    }

    func disbandSelectedPrivatePunchLine() {
        guard let selectedPrivatePunchLineID else { return }
        Task {
            let punchLineWasDeleted = await APIManager.deletePrivatePunchLine(with: selectedPrivatePunchLineID)
            if punchLineWasDeleted {
                AppSessionManager.removeOwnedPrivatePunchLine(with: selectedPrivatePunchLineID)
                GlobalNotificationManager.shared.shouldRefreshPunchLines = true
                if privatePunchLines.isEmpty == true {
                    shouldNavigateBackToSettings = true
                }
            }
        }
    }

    func leaveSelectedPrivatePunchLine() {
        guard let selectedPrivatePunchLineID else { return }
        AppSessionManager.removeJoinedPrivatePunchLine(with: selectedPrivatePunchLineID)
        GlobalNotificationManager.shared.shouldRefreshPunchLines = true
        if privatePunchLines.isEmpty == true {
            shouldNavigateBackToSettings = true
        }
    }

}

enum PrivatePunchLinesListViewMode {
    case owned, joined
}
