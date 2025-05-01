//
//  PunchLineActivityViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import Foundation
import SwiftUI

class PunchLineActivityViewModel: ObservableObject {

    let punchLine: any ActivePunchLine
    private(set) var activity: PunchLineActivity
    @Published var activityDisplayText: String

    @Published var enteredSetupText: String = ""
    @Published var enteredPunchlineText: String = ""

    var fetchedSetups: [Setup] = []
    var fetchedJokes: [Joke] = []

    var lastOwnSetup: Setup?
    var currentSetup: Setup?
    var currentJoke: Joke?

    init(punchLine: any ActivePunchLine, activity: PunchLineActivity, activityDisplayText: String, initialSetupBatch: [Setup], initialJokeBatch: [Joke]) {
        self.punchLine = punchLine
        self.activity = activity
        self.activityDisplayText = activityDisplayText
        self.fetchedSetups = initialSetupBatch
        self.fetchedJokes = initialJokeBatch

        switch activity {
        case .setup:
            break
        case .punchline:
            currentSetup = initialSetupBatch.first
        case .vote:
            currentJoke = initialJokeBatch.first
        case .somethingWentWrong:
            break
        }

        updatePunchLineRelauncher()
    }

    init(punchLine: any ActivePunchLine, activity: PunchLineActivity, activityDisplayText: String, relauncher: PunchLineRelauncher) {
        self.punchLine = punchLine
        self.activity = activity
        self.activityDisplayText = activityDisplayText
        self.fetchedSetups = relauncher.previouslyFetchedSetups
        self.fetchedJokes = relauncher.previouslyFetchedJokes

        switch activity {
        case .setup:
            break
        case .punchline:
            currentSetup = relauncher.currentSetup
        case .vote:
            currentJoke = relauncher.currentJoke
        case .somethingWentWrong:
            break
        }

    }

    // MARK: Data Fetchers

    func fetchSetupBatch() {
        Task {
            let newSetups = await APIManager.getSetups(for: punchLine.id)
            fetchedSetups.append(contentsOf: newSetups)
        }
    }

    func fetchJokeBatch() {
        Task {
            let newJokes = await APIManager.getJokes(for: punchLine.id)
            fetchedJokes.append(contentsOf: newJokes)
        }
    }

    // MARK: General Activity Methods

    func setNextActivity() {

        AppSessionManager.incrementTodaysTaskCount(for: punchLine.id)

        enteredSetupText = ""
        enteredPunchlineText = ""

        switch activity {
        case .setup:
            break
        case .punchline:
            fetchedSetups.removeFirst()
            if fetchedSetups.count < 5 {
                fetchSetupBatch()
            }
        case .vote:
            fetchedJokes.removeFirst()
            if fetchedJokes.count < 5 {
                fetchJokeBatch()
            }
        case .somethingWentWrong:
            break
        }

        let todaysTaskCount = AppSessionManager.taskCount(for: punchLine.id)

        switch todaysTaskCount {
        case 0:
            configureViewForSetup(.first)
        case 1:
            configureViewForOwnPunchline(.first)
        case 2:
            configureViewForSetup(.second)
        case 3:
            configureViewForOwnPunchline(.second)
        case 4:
            configureViewForSetup(.third)
        case 5:
            configureViewForOwnPunchline(.third)
        case 6, 8, 11, 15, 20, 26, 33, 41, 50, 60:
            if lastOwnSetup != nil {
                configureViewForOwnPunchline(.extra)
            } else if fetchedSetups.first != nil {
                configureViewForPunchline()
            } else {
                configureViewForSetup(.extra)
            }
        default:
            if lastOwnSetup != nil {
                configureViewForOwnPunchline(.extra)
            } else if fetchedJokes.first != nil {
                configureViewForJoke()
            } else if fetchedSetups.first != nil {
                configureViewForPunchline()
            } else {
                configureViewForSetup(.extra)
            }
        }

        updatePunchLineRelauncher()

    }

    private func configureViewForSetup(_ taskCount: TaskCounter) {
        switch taskCount {
        case .first:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupFirst
            currentSetup = nil
            currentJoke = nil
        case .second:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupSecond
            currentSetup = nil
            currentJoke = nil
        case .third:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupThird
            currentSetup = nil
            currentJoke = nil
        case .extra:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupExtra
            currentSetup = nil
            currentJoke = nil
        }
    }

    private func configureViewForOwnPunchline(_ taskCount: TaskCounter) {
        guard let ownSetup = lastOwnSetup else {
            configureViewForError()
            return
        }

        switch taskCount {
        case .first:
            activity = .punchline
            activityDisplayText = ActivityFeedMessages.ownPunchlineFirst
            currentSetup = ownSetup
            currentJoke = nil
            lastOwnSetup = nil
        case .second:
            activity = .punchline
            activityDisplayText = ActivityFeedMessages.ownPunchlineSecond
            currentSetup = ownSetup
            currentJoke = nil
            lastOwnSetup = nil
        case .third:
            activity = .punchline
            activityDisplayText = ActivityFeedMessages.ownPunchlineThird
            currentSetup = ownSetup
            currentJoke = nil
            lastOwnSetup = nil
        case .extra:
            activity = .punchline
            activityDisplayText = ActivityFeedMessages.ownPunchlineExtra
            currentSetup = ownSetup
            currentJoke = nil
            lastOwnSetup = nil
        }

    }

    private func configureViewForPunchline() {
        guard let fetchedSetup = fetchedSetups.first else {
            configureViewForError()
            return
        }

        activity = .punchline
        activityDisplayText = ActivityFeedMessages.punchline
        currentSetup = fetchedSetup
        currentJoke = nil
    }

    private func configureViewForJoke() {
        guard let fetchedJoke = fetchedJokes.first else {
            configureViewForError()
            return
        }

        activity = .vote
        activityDisplayText = ActivityFeedMessages.vote
        currentJoke = fetchedJoke
        currentSetup = nil
    }

    private func configureViewForError() {
        activity = .somethingWentWrong
        activityDisplayText = ""
        currentSetup = nil
        currentJoke = nil
    }

    func textEntryIsValid() -> Bool {

        switch activity {
        case .setup:
            guard enteredSetupText.removingSpaces().count >= 10 else {
                return false
            }

            guard enteredSetupText.last == "?" || enteredSetupText.last == "…" else {
                return false
            }

            guard !enteredSetupText.containsBannedWords() else {
                return false
            }

            return true
        case .punchline:
            guard enteredPunchlineText.removingSpaces().count >= 2 else {
                return false
            }

            guard !enteredPunchlineText.containsBannedWords() else {
                return false
            }

            return true
        case .vote:
            return true
        case .somethingWentWrong:
            return true
        }

    }

    func updatePunchLineRelauncher() {

        let relauncher = PunchLineRelauncher(
            previouslyFetchedSetups: fetchedSetups,
            previouslyFetchedJokes: fetchedJokes,
            currentSetup: currentSetup,
            currentJoke: currentJoke
        )

        AppSessionManager.punchLineRelaunchers[punchLine.id] = relauncher

    }

    // MARK: Setup Methods

    func createNewSetup() {
        guard let userInfo = AppSessionManager.userInfo else { return }

        let ownSetup = Setup(
            id: "",
            punchLineID: punchLine.id,
            text: enteredSetupText,
            authorID: userInfo.punchLineUserID,
            authorUsername: userInfo.hasPunchLinePro ? userInfo.punchLineUserName : nil,
            dateCreated: Date(),
            isOffensive: false
        )
        self.lastOwnSetup = ownSetup

        let setupPostRequest = SetupPostRequest(
            punchLineID: punchLine.id,
            text: enteredSetupText,
            authorID: userInfo.punchLineUserID,
            authorUsername: userInfo.hasPunchLinePro ? userInfo.punchLineUserName : nil
        )

        Task {
            await APIManager.post(setup: setupPostRequest)
        }

    }

    // MARK: Punchline Methods

    func reportCurrentSetup(for reportReason: SetupReportReason) {
        guard let setup = currentSetup else { return }
        Task {
            await APIManager.report(setup: setup, for: reportReason)
        }
    }

    func createNewJoke() {
        guard let userInfo = AppSessionManager.userInfo else { return }
        guard let setup = currentSetup else { return }
        let jokePostRequest = JokePostRequest(
            punchLineID: punchLine.id,
            punchLineDisplayName: punchLine.displayName,
            setup: setup.text,
            setupID: setup.id,
            setupAuthorID: setup.authorID,
            setupAuthorUsername: setup.authorUsername,
            punchline: enteredPunchlineText,
            punchlineAuthorID: userInfo.punchLineUserID,
            punchlineAuthorUsername: userInfo.hasPunchLinePro ? userInfo.punchLineUserName : nil
        )
        Task {
            await APIManager.post(joke: jokePostRequest)
        }
    }

    // MARK: Vote Methods

    func voteOnCurrentJoke(vote: JokeVote) {
        guard let joke = currentJoke else { return }
        Task {
            await APIManager.voteOn(joke: joke, with: vote)
        }
    }

    func getTooFunnyReportsCount() -> Int {
        return AppSessionManager.userInfo?.dailyTooFunnyReportsCount ?? 0
    }

    func reportCurrentJoke(for reportReason: JokeReportReason) {
        guard let joke = currentJoke else { return }
        if reportReason == .tooFunny {
            AppSessionManager.incrementDailyTooFunnyReportsCount()
        }
        Task {
            await APIManager.report(joke: joke, for: reportReason)
        }
    }

}

enum PunchLineActivity {
    case setup, punchline, vote, somethingWentWrong
}

enum TaskCounter {
    case first, second, third, extra
}
