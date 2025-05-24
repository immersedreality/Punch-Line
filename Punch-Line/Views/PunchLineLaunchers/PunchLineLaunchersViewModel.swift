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
    private var selectedPunchLineID: String? {
        if let selectedPublicPunchLineID = selectedPublicPunchLine?.id {
            return selectedPublicPunchLineID
        } else if let selectedPrivatePunchLineID = selectedPrivatePunchLine?.id {
            return selectedPrivatePunchLineID
        } else {
            return nil
        }
    }

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

    func initializePunchLineActivityViewModel() async -> PunchLineActivityViewModel? {
        var activePunchLine: (any ActivePunchLine)?

        if let punchLine = selectedPublicPunchLine {
            activePunchLine = punchLine
        } else if let punchLine = selectedPrivatePunchLine {
            activePunchLine = punchLine
        }

        guard let activePunchLine else { return nil }

        if let relauncher = AppSessionManager.punchLineRelaunchers[activePunchLine.id] {
            let punchLineHasSetups = !relauncher.previouslyFetchedSetups.isEmpty || relauncher.currentSetup != nil
            let punchLineHasJokes = !relauncher.previouslyFetchedJokes.isEmpty || relauncher.currentJoke != nil
            return PunchLineActivityViewModel(
                punchLine: activePunchLine,
                activity: getInitialPunchLineActivity(punchLineHasSetups: punchLineHasSetups, punchLineHasJokes: punchLineHasJokes),
                activityDisplayText: getInitialPunchLineActivityDisplayText(for: .relaunch, punchLineHasSetups: punchLineHasSetups, punchLineHasJokes: punchLineHasJokes),
                relauncher: relauncher
            )
        } else {
            let fetchedSetups = await fetchSetupBatch()
            let fetchedJokes = await fetchJokeBatch()
            return PunchLineActivityViewModel(
                punchLine: activePunchLine,
                activity: getInitialPunchLineActivity(punchLineHasSetups: !fetchedSetups.isEmpty, punchLineHasJokes: !fetchedJokes.isEmpty),
                activityDisplayText: getInitialPunchLineActivityDisplayText(for: .initial, punchLineHasSetups: !fetchedSetups.isEmpty, punchLineHasJokes: !fetchedJokes.isEmpty),
                initialSetupBatch: fetchedSetups,
                initialJokeBatch: fetchedJokes
            )
        }

    }

    func getInitialPunchLineActivity(punchLineHasSetups: Bool, punchLineHasJokes: Bool) -> PunchLineActivity {

        var selectedPunchLineID: String?

        if let selectedPublicPunchLineID = selectedPublicPunchLine?.id {
            selectedPunchLineID = selectedPublicPunchLineID
        } else if let selectedPrivatePunchLineID = selectedPrivatePunchLine?.id {
            selectedPunchLineID = selectedPrivatePunchLineID
        }

        guard let selectedPunchLineID else {
            return .somethingWentWrong
        }

        AppSessionManager.resetDailyPropertiesIfNecessary()

        let todaysTaskCount = AppSessionManager.taskCount(for: selectedPunchLineID)
        let userIsNotFunny = AppSessionManager.userInfo?.userIsNotFunny ?? false

        if userIsNotFunny {
            switch todaysTaskCount {
            case 0, 1, 2:
                return .setup
            default:
                if punchLineHasJokes {
                    return .vote
                } else {
                    return .setup
                }
            }
        } else {
            switch todaysTaskCount {
            case 0, 2, 4:
                return .setup
            case 1, 3, 5, 6, 8, 11, 15, 20, 26, 33, 41, 50, 60:
                if punchLineHasSetups {
                    return .punchline
                } else {
                    return .setup
                }
            default:
                if punchLineHasJokes {
                    return .vote
                } else if punchLineHasSetups {
                    return .punchline
                } else {
                    return .setup
                }
            }
        }
        
    }

    func getInitialPunchLineActivityDisplayText(for mode: ActivityDisplayTextGenerationMode, punchLineHasSetups: Bool, punchLineHasJokes: Bool) -> String {

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
        let userIsNotFunny = AppSessionManager.userInfo?.userIsNotFunny ?? false

        if userIsNotFunny {
            switch todaysTaskCount {
            case 0:
                return ActivityFeedMessages.setupFirst
            case 1:
                return ActivityFeedMessages.setupSecond
            case 2:
                return ActivityFeedMessages.setupThird
            default:
                if punchLineHasJokes {
                    return ActivityFeedMessages.vote
                } else {
                    return ActivityFeedMessages.setupExtra
                }
            }
        } else {
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
                if punchLineHasSetups {
                    return ActivityFeedMessages.punchlineGeneric
                } else {
                    return ActivityFeedMessages.setupExtra
                }
            default:
                if punchLineHasJokes {
                    return ActivityFeedMessages.vote
                } else if punchLineHasSetups {
                    return ActivityFeedMessages.punchlineGeneric
                } else {
                    return ActivityFeedMessages.setupExtra
                }
            }
        }

    }

    func getPunchLineRelauncher() -> PunchLineRelauncher? {
        guard let selectedPunchLineID else { return nil }
        return AppSessionManager.punchLineRelaunchers[selectedPunchLineID]
    }

    func fetchSetupBatch() async -> [Setup] {
        guard let selectedPunchLineID else { return [] }
        let setups = await APIManager.fetchSetups(for: selectedPunchLineID)
        return setups
    }

    func fetchJokeBatch() async -> [Joke ] {
        guard let selectedPunchLineID else { return [] }
        let jokes = await APIManager.fetchJokes(for: selectedPunchLineID)
        return jokes
    }

}

enum ActivityDisplayTextGenerationMode {
    case initial, relaunch
}
