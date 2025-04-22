//
//  PunchLineLaunchersViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import Foundation

class PunchLineLaunchersViewModel: ObservableObject {

    let fetchedPublicPunchLines: [PublicPunchLine]
    private(set) var selectedPublicPunchLine: PublicPunchLine?

    let fetchedPrivatePunchLines: [PrivatePunchLine]
    private(set) var selectedPrivatePunchLine: PrivatePunchLine?

    @Published var showingPunchLineSheet = false

    init(fetchedPublicPunchLines: [PublicPunchLine], fetchedPrivatePunchLines: [PrivatePunchLine]) {
        self.fetchedPublicPunchLines = fetchedPublicPunchLines
        self.fetchedPrivatePunchLines = fetchedPrivatePunchLines
    }

    func setSelected(publicPunchLine: PublicPunchLine) {
        selectedPublicPunchLine = publicPunchLine
        selectedPrivatePunchLine = nil
        showingPunchLineSheet = true
    }

    func setSelected(privatePunchLine: PrivatePunchLine) {
        selectedPrivatePunchLine = privatePunchLine
        selectedPublicPunchLine = nil
        showingPunchLineSheet = true
    }

    func getInitialPunchLineActivity() -> PunchLineActivity {

        var selectedPunchLineID: String?

        if let selectedPublicPunchLineID = selectedPublicPunchLine?.id {
            selectedPunchLineID = selectedPublicPunchLineID
        }

        if let selectedPrivatePunchLineID = selectedPrivatePunchLine?.id {
            selectedPunchLineID = selectedPrivatePunchLineID
        }

        guard let selectedPunchLineID else {
            return .somethingWentWrong
        }

        AppSessionManager.resetTaskCountsIfNecessary()

        if let todaysTaskCount = AppSessionManager.userInfo?.todaysTaskCounts[selectedPunchLineID] {
            switch todaysTaskCount {
            case 0, 1, 2:
                return .setup
            case 3, 5, 8, 12, 17, 23, 30, 38, 47, 57:
                return .punchline
            default:
                return .vote
            }
        } else {
            AppSessionManager.createTaskCountKey(for: selectedPunchLineID)
            return .setup
        }

    }

    func getInitialPunchLineActivityDisplayText() -> String {

        var selectedPunchLineID: String?

        if let selectedPublicPunchLineID = selectedPublicPunchLine?.id {
            selectedPunchLineID = selectedPublicPunchLineID
        } else if let selectedPrivatePunchLineID = selectedPrivatePunchLine?.id {
            selectedPunchLineID = selectedPrivatePunchLineID
        }

        guard let selectedPunchLineID else {
            return ActivityFeedMessages.weDoneGoofed
        }

        if let todaysTaskCount = AppSessionManager.userInfo?.todaysTaskCounts[selectedPunchLineID] {
            switch todaysTaskCount {
            case 0:
                return ActivityFeedMessages.setupFirst
            case 1:
                return ActivityFeedMessages.setupSecond
            case 2:
                return ActivityFeedMessages.setupThird
            case 3, 5, 8, 12, 17, 23, 30, 38, 47, 57:
                return ActivityFeedMessages.punchline
            default:
                return ActivityFeedMessages.vote
            }
        } else {
            return ActivityFeedMessages.weDoneGoofed
        }

    }


}
