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

    @Published var privatePunchLines: [PrivatePunchLine] = []
    private var selectedPrivatePunchLineID: String?

    @Published var shouldNavigateBackToSettings = false

    init(mode: PrivatePunchLinesListViewMode) {
        self.mode = mode
        setPrivatePunchLines()
    }

    func setPrivatePunchLines() {
        switch mode {
        case .owned:
            privatePunchLines = AppSessionManager.userInfo?.ownedPrivatePunchLines ?? []
        case .joined:
            privatePunchLines = AppSessionManager.userInfo?.joinedPrivatePunchLines ?? []
        }
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
                setPrivatePunchLines()
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
        setPrivatePunchLines()
        if privatePunchLines.isEmpty == true {
            shouldNavigateBackToSettings = true
        }
    }

}

enum PrivatePunchLinesListViewMode {
    case owned, joined
}
