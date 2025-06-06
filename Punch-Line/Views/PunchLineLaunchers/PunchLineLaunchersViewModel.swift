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

        AppSessionManager.resetDailyPropertiesIfNecessary()

        if let relauncher = AppSessionManager.punchLineRelaunchers[activePunchLine.id] {
            if relauncher.currentSetup != nil {
                return PunchLineActivityViewModel(
                    punchLine: activePunchLine,
                    activity: .punchline,
                    activityDisplayText: getInitialPunchLineActivityDisplayText(for: .relaunch, punchLineHasSetups: true, punchLineHasJokes: false),
                    relauncher: relauncher
                )
            } else if relauncher.currentJoke != nil {
                return PunchLineActivityViewModel(
                    punchLine: activePunchLine,
                    activity: .vote,
                    activityDisplayText: getInitialPunchLineActivityDisplayText(for: .relaunch, punchLineHasSetups: false, punchLineHasJokes: true),
                    relauncher: relauncher
                )
            } else {
                let punchLineHasSetups = !relauncher.previouslyFetchedSetups.isEmpty
                let punchLineHasJokes = !relauncher.previouslyFetchedJokes.isEmpty
                return PunchLineActivityViewModel(
                    punchLine: activePunchLine,
                    activity: getInitialPunchLineActivity(punchLineHasSetups: punchLineHasSetups, punchLineHasJokes: punchLineHasJokes),
                    activityDisplayText: getInitialPunchLineActivityDisplayText(for: .relaunch, punchLineHasSetups: punchLineHasSetups, punchLineHasJokes: punchLineHasJokes),
                    relauncher: relauncher
                )
            }
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

        guard !AppSessionManager.userIsInTraining else {
            return generateTrainingActivity(punchLineHasSetups: punchLineHasSetups, punchLineHasJokes: punchLineHasJokes)
        }

        let todaysTaskCount = AppSessionManager.taskCount(for: selectedPunchLineID)
        let userIsNotFunny = AppSessionManager.userInfo?.userIsNotFunny ?? false
        let usersNameIsJerry = AppSessionManager.userInfo?.usersNameIsJerry ?? false

        if userIsNotFunny {
            switch todaysTaskCount {
            case 0, 6, 12:
                return .setup
            default:
                if punchLineHasJokes {
                    return .vote
                } else {
                    return .setup
                }
            }
        } else if usersNameIsJerry {
            if punchLineHasJokes {
                return .vote
            } else if punchLineHasSetups {
                return .punchline
            } else {
                return .setup
            }
        } else {
            switch todaysTaskCount {
            case 0, 6, 12:
                return .setup
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

    private func generateTrainingActivity(punchLineHasSetups: Bool, punchLineHasJokes: Bool) -> PunchLineActivity {
        let todaysTaskCount = AppSessionManager.trainingTaskCount

        switch todaysTaskCount {
        case 4, 9:
            if punchLineHasSetups {
                return .punchline
            } else if punchLineHasJokes {
                return .vote
            } else {
                return .setup
            }
        case 10:
            return .setup
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

        guard !AppSessionManager.userIsInTraining else {
            return generateTrainingActivityDisplayText(punchLineHasSetups: punchLineHasSetups, punchLineHasJokes: punchLineHasJokes)
        }

        let todaysTaskCount = AppSessionManager.taskCount(for: selectedPunchLineID)
        let userIsNotFunny = AppSessionManager.userInfo?.userIsNotFunny ?? false
        let usersNameIsJerry = AppSessionManager.userInfo?.usersNameIsJerry ?? false

        if userIsNotFunny {
            switch todaysTaskCount {
            case 0:
                return ActivityFeedMessages.setupFirst
            case 6:
                return ActivityFeedMessages.setupSecond
            case 12:
                return ActivityFeedMessages.setupThird
            default:
                if punchLineHasJokes {
                    return ActivityFeedMessages.vote
                } else {
                    return ActivityFeedMessages.setupExtra
                }
            }
        } else if usersNameIsJerry {
            if punchLineHasJokes {
                return ActivityFeedMessages.vote
            } else if punchLineHasSetups {
                return ActivityFeedMessages.punchlineGeneric
            } else {
                return ActivityFeedMessages.setupGeneric
            }
        } else {
            switch todaysTaskCount {
            case 0:
                return ActivityFeedMessages.setupFirst
            case 1:
                if mode == .relaunch {
                    return ActivityFeedMessages.ownPunchlineFirst
                } else {
                    if punchLineHasSetups {
                        return ActivityFeedMessages.punchline
                    } else {
                        return ActivityFeedMessages.setupGeneric
                    }
                }
            case 6:
                return ActivityFeedMessages.setupSecond
            case 7:
                if mode == .relaunch {
                    return ActivityFeedMessages.ownPunchlineSecond
                } else {
                    if punchLineHasSetups {
                        return ActivityFeedMessages.punchline
                    } else {
                        return ActivityFeedMessages.setupGeneric
                    }
                }
            case 12:
                return ActivityFeedMessages.setupThird
            case 13:
                if mode == .relaunch {
                    return ActivityFeedMessages.ownPunchlineThird
                } else {
                    if punchLineHasSetups {
                        return ActivityFeedMessages.punchline
                    } else {
                        return ActivityFeedMessages.setupGeneric
                    }
                }
            default:
                if punchLineHasJokes {
                    return ActivityFeedMessages.vote
                } else if punchLineHasSetups {
                    return ActivityFeedMessages.punchlineGeneric
                } else {
                    return ActivityFeedMessages.setupGeneric
                }
            }
        }

    }

    private func generateTrainingActivityDisplayText(punchLineHasSetups: Bool, punchLineHasJokes: Bool) -> String {
        let todaysTaskCount = AppSessionManager.trainingTaskCount

        switch todaysTaskCount {
        case 4, 9:
            if punchLineHasSetups {
                return ActivityFeedMessages.punchline
            } else if punchLineHasJokes {
                return ActivityFeedMessages.vote
            } else {
                return ActivityFeedMessages.setupTraining
            }
        case 10:
            return ActivityFeedMessages.setupFirst
        default:
            if punchLineHasJokes {
                return ActivityFeedMessages.vote
            } else if punchLineHasSetups {
                return ActivityFeedMessages.punchline
            } else {
                return ActivityFeedMessages.setupTraining
            }
        }

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
