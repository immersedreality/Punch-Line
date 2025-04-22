//
//  CreateOrJoinPrivatePunchLineViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import Foundation

class CreateOrJoinPrivatePunchLineViewModel: ObservableObject {

    let mode: CreateOrJoinPrivatePunchLineViewMode

    var displayText: String {
        switch mode {
        case .create:
            return "Enter A Name For Your Private Punch-Line"
        case .join:
            return "Enter The Code Of The Private Punch-Line You Wish To Join"
        }
    }

    @Published var enteredText: String = ""
    @Published var showingErrorAlert: Bool = false
    @Published var shouldNavigateToSuccessScreen: Bool = false

    var errorAlertMessage: String {
        switch mode {
        case .create:
            return "Could not create Punch-Line.  Please check your network connection and try again."
        case .join:
            return "Could not join Punch-Line.  Please check that your code is correct and try again."
        }
    }

    var createdPunchLineJoinCode: String = ""
    var punchLineDisplayName: String = ""
    var successMessage: String {
        switch mode {
        case .create:
            return "\(punchLineDisplayName) Created!\n\nGive this code to anyone you'd like to join \(punchLineDisplayName): \(createdPunchLineJoinCode)"
        case .join:
            return "\(punchLineDisplayName) Successfully Joined!"
        }
    }

    init(mode: CreateOrJoinPrivatePunchLineViewMode) {
        self.mode = mode
    }

    func textEntryIsValid() -> Bool {

        switch mode {
        case .create:
            guard enteredText.removingSpaces().count >= 3 else {
                return false
            }

            guard enteredText.count <= 24 else {
                return false
            }

            guard !enteredText.containsBannedWords() else {
                return false
            }

            return true
        case .join:
            guard enteredText.removingSpaces().count == 6 else {
                return false
            }

            return true
        }

    }

    func createPrivatePunchLine() {
        guard let userInfo = AppSessionManager.userInfo, let userName = userInfo.punchLineUserName else { return }

        let privatePunchLinePostRequest = PrivatePunchLinePostRequest(
            displayName: enteredText,
            owningUserID: userInfo.punchLineUserID,
            owningUserName: userName
        )

        Task {
            if let createdPrivatePunchLine = await APIManager.post(privatePunchLine: privatePunchLinePostRequest) {
                createdPunchLineJoinCode = createdPrivatePunchLine.joinCode
                punchLineDisplayName = createdPrivatePunchLine.displayName
                AppSessionManager.add(privatePunchLine: createdPrivatePunchLine)
                shouldNavigateToSuccessScreen = true
            } else {
                showingErrorAlert = true
            }
        }
    }

    func joinPrivatePunchLine() {
        Task {
            let joinedPrivatePunchLines = await APIManager.getPrivatePunchLine(with: enteredText.uppercased())
            if let joinedPrivatePunchLine = joinedPrivatePunchLines.first {
                punchLineDisplayName = joinedPrivatePunchLine.displayName
                AppSessionManager.add(privatePunchLine: joinedPrivatePunchLine)
                shouldNavigateToSuccessScreen = true
            } else {
                showingErrorAlert = true
            }
        }
    }

}

enum CreateOrJoinPrivatePunchLineViewMode {
    case create, join
}
