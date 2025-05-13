//
//  PrivatePunchLinesListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import SwiftUI

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
    private var selectedPrivatePunchLine: PrivatePunchLine?

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

    func set(selectedPrivatePunchLine: PrivatePunchLine) {
        self.selectedPrivatePunchLine = selectedPrivatePunchLine
    }

    func disbandSelectedPrivatePunchLine() {
        guard let selectedPrivatePunchLine else { return }
        Task {
            let punchLineWasDeleted = await APIManager.deletePrivatePunchLine(with: selectedPrivatePunchLine.id)
            if punchLineWasDeleted {
                AppSessionManager.removeOwnedPrivatePunchLine(with: selectedPrivatePunchLine.id)
                GlobalNotificationManager.shared.shouldRefreshPunchLines = true
                setPrivatePunchLines()
                if privatePunchLines.isEmpty == true {
                    shouldNavigateBackToSettings = true
                }
            }
        }
    }

    func leaveSelectedPrivatePunchLine() {
        guard let selectedPrivatePunchLine else { return }
        AppSessionManager.removeJoinedPrivatePunchLine(with: selectedPrivatePunchLine.id)
        GlobalNotificationManager.shared.shouldRefreshPunchLines = true
        setPrivatePunchLines()
        if privatePunchLines.isEmpty == true {
            shouldNavigateBackToSettings = true
        }
    }

    func copyShareableJoinCode() {
        guard let selectedPrivatePunchLine else { return }
        UIPasteboard.general.string = selectedPrivatePunchLine.joinCode
    }

}

enum PrivatePunchLinesListViewMode {
    case owned, joined
}
