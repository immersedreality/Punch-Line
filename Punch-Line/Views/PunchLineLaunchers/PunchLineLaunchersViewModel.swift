//
//  PunchLineLaunchersViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import Foundation

class PunchLineLaunchersViewModel {

    let fetchedPublicPunchLines: [PublicPunchLine]
    private(set) var selectedPublicPunchLine: PublicPunchLine?

    let fetchedPrivatePunchLines: [PrivatePunchLine]
    private(set) var selectedPrivatePunchLine: PrivatePunchLine?

    var punchLineActivityViewModel: PunchLineActivityViewModel?
    
    init(fetchedPublicPunchLines: [PublicPunchLine], fetchedPrivatePunchLines: [PrivatePunchLine]) {
        self.fetchedPublicPunchLines = fetchedPublicPunchLines
        self.fetchedPrivatePunchLines = fetchedPrivatePunchLines
    }

    func setSelected(publicPunchLine: PublicPunchLine) {
        selectedPublicPunchLine = publicPunchLine
        selectedPrivatePunchLine = nil
    }

    func setSelected(privatePunchLine: PrivatePunchLine) {
        selectedPrivatePunchLine = privatePunchLine
        selectedPublicPunchLine = nil
    }

    // MARK: PunchLine Launch Methods

    func initializePunchLineActivityViewModel() async {
        var activePunchLine: (any ActivePunchLine)?

        if let punchLine = selectedPublicPunchLine {
            activePunchLine = punchLine
        } else if let punchLine = selectedPrivatePunchLine {
            activePunchLine = punchLine
        }

        guard let activePunchLine else { return }

        if let relauncher = AppSessionManager.punchLineRelaunchers[activePunchLine.id] {
            punchLineActivityViewModel = PunchLineActivityViewModel(
                punchLine: activePunchLine,
                activity: getInitialPunchLineActivity(),
                activityDisplayText: getInitialPunchLineActivityDisplayText(for: .relaunch),
                relauncher: relauncher
            )
        } else {
            let fetchedSetups = await fetchSetupBatch()
            let fetchedJokes = await fetchJokeBatch()
            punchLineActivityViewModel = PunchLineActivityViewModel(
                punchLine: activePunchLine,
                activity: getInitialPunchLineActivity(),
                activityDisplayText: getInitialPunchLineActivityDisplayText(for: .initial),
                initialSetupBatch: fetchedSetups,
                initialJokeBatch: fetchedJokes
            )
        }

    }

    func getInitialPunchLineActivity() -> PunchLineActivity {

        var selectedPunchLineID: String?

        if let selectedPublicPunchLineID = selectedPublicPunchLine?.id {
            selectedPunchLineID = selectedPublicPunchLineID
        } else if let selectedPrivatePunchLineID = selectedPrivatePunchLine?.id {
            selectedPunchLineID = selectedPrivatePunchLineID
        }

        guard let selectedPunchLineID else {
            return .somethingWentWrong
        }

        AppSessionManager.resetTaskCountsIfNecessary()

        let todaysTaskCount = AppSessionManager.taskCount(for: selectedPunchLineID)

        switch todaysTaskCount {
        case 0, 2, 4:
            return .setup
        case 1, 3, 5, 6, 8, 11, 15, 20, 26, 33, 41, 50, 60:
            return .punchline
        default:
            return .vote
        }
        
    }

    func getInitialPunchLineActivityDisplayText(for mode: ActivityDisplayTextGenerationMode) -> String {

        var selectedPunchLineID: String?

        if let selectedPublicPunchLineID = selectedPublicPunchLine?.id {
            selectedPunchLineID = selectedPublicPunchLineID
        } else if let selectedPrivatePunchLineID = selectedPrivatePunchLine?.id {
            selectedPunchLineID = selectedPrivatePunchLineID
        }

        guard let selectedPunchLineID else {
            return ActivityFeedMessages.weDoneGoofed
        }

        let todaysTaskCount = AppSessionManager.taskCount(for: selectedPunchLineID)

        switch todaysTaskCount {
        case 0:
            return ActivityFeedMessages.setupFirst
        case 1:
            return mode == .relaunch ? ActivityFeedMessages.ownPunchlineFirst : ActivityFeedMessages.punchline
        case 2:
            return ActivityFeedMessages.setupSecond
        case 3:
            return mode == .relaunch ? ActivityFeedMessages.ownPunchlineSecond : ActivityFeedMessages.punchline
        case 4:
            return ActivityFeedMessages.setupThird
        case 5:
            return mode == .relaunch ? ActivityFeedMessages.ownPunchlineThird : ActivityFeedMessages.punchline
        case 6, 8, 11, 15, 20, 26, 33, 41, 50, 60:
            return ActivityFeedMessages.punchline
        default:
            return ActivityFeedMessages.vote
        }

    }

    func getPunchLineRelauncher() -> PunchLineRelauncher? {

        var selectedPunchLineID: String?

        if let selectedPublicPunchLineID = selectedPublicPunchLine?.id {
            selectedPunchLineID = selectedPublicPunchLineID
        } else if let selectedPrivatePunchLineID = selectedPrivatePunchLine?.id {
            selectedPunchLineID = selectedPrivatePunchLineID
        }

        guard let selectedPunchLineID else {
            return nil
        }

        return AppSessionManager.punchLineRelaunchers[selectedPunchLineID]
        
    }

    func fetchSetupBatch() async -> [Setup] {
        let setups = await APIManager.getSetups()
        return setups
    }

    func fetchJokeBatch() async -> [Joke ]{
        let jokes = await APIManager.getJokes()
        return jokes
    }

}

enum ActivityDisplayTextGenerationMode {
    case initial, relaunch
}
