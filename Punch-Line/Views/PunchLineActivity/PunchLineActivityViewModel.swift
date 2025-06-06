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
            if !self.fetchedSetups.isEmpty {
                self.fetchedSetups.removeFirst()
            }
        case .vote:
            currentJoke = initialJokeBatch.first
            if !self.fetchedJokes.isEmpty {
                self.fetchedJokes.removeFirst()
            }
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
            currentSetup = relauncher.currentSetup ?? fetchedSetups.first
            if !self.fetchedSetups.isEmpty {
                self.fetchedSetups.removeFirst()
            }
        case .vote:
            currentJoke = relauncher.currentJoke ?? fetchedJokes.first
            if !self.fetchedJokes.isEmpty {
                self.fetchedJokes.removeFirst()
            }
        case .somethingWentWrong:
            break
        }

    }

    // MARK: Data Fetchers

    func fetchSetupBatchIfNeeded() {
        guard fetchedSetups.count < 5 else { return }

        Task {
            let newSetups = await APIManager.fetchSetups(for: punchLine.id)
            let fetchedSetupIDs = fetchedSetups.map { $0.id }
            newSetups.forEach {
                if !fetchedSetupIDs.contains($0.id) {
                    fetchedSetups.append($0)
                }
            }
        }
    }

    func fetchJokeBatchIfNeeded() {
        guard fetchedJokes.count < 5 else { return }

        Task {
            let newJokes = await APIManager.fetchJokes(for: punchLine.id)
            let fetchedJokeIDs = fetchedJokes.map { $0.id }
            newJokes.forEach {
                if !fetchedJokeIDs.contains($0.id) {
                    fetchedJokes.append($0)
                }
            }
        }
    }

    // MARK: General Activity Methods

    func setNextActivity() {

        guard !AppSessionManager.userIsInTraining else {
            setNextActivityForTrainingMode()
            return
        }

        if AppSessionManager.dailyPropertiesWillBeReset() {
            fetchedSetups = []
            fetchedJokes = []
            fetchSetupBatchIfNeeded()
            fetchJokeBatchIfNeeded()
        }

        AppSessionManager.incrementTodaysTaskCount(for: punchLine.id)

        guard AppSessionManager.userInfo?.userIsNotFunny != true else {
            setNextActivityForUnfunnyUser()
            return
        }

        guard AppSessionManager.userInfo?.usersNameIsJerry != true else {
            setNextActivityForJerry()
            return
        }

        let todaysTaskCount = AppSessionManager.taskCount(for: punchLine.id)

        switch todaysTaskCount {
        case 0:
            configureViewForSetup(.first)
        case 1:
            configureViewForOwnPunchline(.first)
        case 6:
            configureViewForSetup(.second)
        case 7:
            configureViewForOwnPunchline(.second)
        case 12:
            configureViewForSetup(.third)
        case 13:
            configureViewForOwnPunchline(.third)
        default:
            if lastOwnSetup != nil {
                configureViewForOwnPunchline(.extra)
                fetchSetupBatchIfNeeded()
                fetchJokeBatchIfNeeded()
            } else if fetchedJokes.first != nil && fetchedSetups.first != nil {
                let randomNumber = Int.random(in: 1...5)
                if randomNumber == 1 {
                    configureViewForPunchline()
                } else {
                    configureViewForJoke()
                }
            } else if fetchedJokes.first != nil {
                configureViewForJoke()
                fetchSetupBatchIfNeeded()
            } else if fetchedSetups.first != nil {
                configureViewForPunchline()
                fetchJokeBatchIfNeeded()
            } else {
                configureViewForSetup(.extra)
                fetchSetupBatchIfNeeded()
                fetchJokeBatchIfNeeded()
            }
        }

        updatePunchLineRelauncher()

    }

    private func setNextActivityForTrainingMode() {

        AppSessionManager.trainingTaskCount += 1
        let todaysTaskCount = AppSessionManager.trainingTaskCount

        switch todaysTaskCount {
        case 4, 9:
            if fetchedSetups.first != nil {
                configureViewForPunchline()
            } else if fetchedJokes.first != nil {
                configureViewForJoke()
                fetchSetupBatchIfNeeded()
            } else {
                configureViewForSetup(.training)
                fetchSetupBatchIfNeeded()
                fetchJokeBatchIfNeeded()
            }
        case 10:
            configureViewForSetup(.first)
        default:
            if fetchedJokes.first != nil {
                configureViewForJoke()
            } else if fetchedSetups.first != nil {
                configureViewForPunchline()
                fetchJokeBatchIfNeeded()
            } else {
                configureViewForSetup(.training)
                fetchSetupBatchIfNeeded()
                fetchJokeBatchIfNeeded()
            }
        }

        updatePunchLineRelauncher()

    }

    private func setNextActivityForUnfunnyUser() {

        let todaysTaskCount = AppSessionManager.taskCount(for: punchLine.id)

        switch todaysTaskCount {
        case 0:
            configureViewForSetup(.first)
        case 6:
            configureViewForSetup(.second)
        case 12:
            configureViewForSetup(.third)
        default:
            if fetchedJokes.first != nil {
                configureViewForJoke()
            } else {
                configureViewForSetup(.extra)
                fetchJokeBatchIfNeeded()
            }
        }

        updatePunchLineRelauncher()

    }

    private func setNextActivityForJerry() {

        if lastOwnSetup != nil {
            configureViewForOwnPunchline(.extra)
            fetchJokeBatchIfNeeded()
        } else if fetchedJokes.first != nil && fetchedSetups.first != nil {
            let randomNumber = Int.random(in: 1...5)
            if randomNumber == 1 {
                configureViewForPunchline()
            } else {
                configureViewForJoke()
            }
        } else if fetchedSetups.first != nil {
            configureViewForPunchline()
            fetchJokeBatchIfNeeded()
        } else if fetchedJokes.first != nil {
            configureViewForJoke()
            fetchSetupBatchIfNeeded()
        } else {
            configureViewForSetup(.extra)
            fetchSetupBatchIfNeeded()
            fetchJokeBatchIfNeeded()
        }

        updatePunchLineRelauncher()

    }

    private func configureViewForSetup(_ taskType: TaskType) {

        enteredSetupText = ""

        switch taskType {
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
        case .training:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupTraining
            currentSetup = nil
            currentJoke = nil
        }

    }

    private func configureViewForOwnPunchline(_ taskType: TaskType) {
        guard let ownSetup = lastOwnSetup else {
            configureViewForError()
            return
        }

        enteredPunchlineText = ""

        switch taskType {
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
        case .training:
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

        enteredPunchlineText = ""

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

            let trimmedSetupText = enteredSetupText.trimTrailingWhiteSpace()

            guard trimmedSetupText.last == "?" || trimmedSetupText.last == "…" else {
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
            text: enteredSetupText.trimTrailingWhiteSpace(),
            authorID: userInfo.punchLineUserID,
            authorUsername: userInfo.punchLineUsername,
            dateCreated: Date(),
            isOffensive: false
        )
        self.lastOwnSetup = ownSetup

        let setupPostRequest = SetupPostRequest(
            punchLineID: punchLine.id,
            text: enteredSetupText,
            authorID: userInfo.punchLineUserID,
            authorUsername: userInfo.punchLineUsername
        )

        Task {
            await APIManager.post(setup: setupPostRequest)
        }

    }

    // MARK: Punchline Methods

    func reportCurrentSetup(for reportReason: SetupReportReason) {
        guard let setup = currentSetup else { return }

        AppSessionManager.addSetup(interactionID: setup.id, for: punchLine.id)

        if !fetchedSetups.isEmpty {
            fetchedSetups.removeFirst()
        }
        fetchSetupBatchIfNeeded()

        Task {
            await APIManager.report(setup: setup, for: reportReason)
        }

    }

    func createNewJoke() {
        guard let userInfo = AppSessionManager.userInfo else { return }
        guard let setup = currentSetup else { return }

        AppSessionManager.addSetup(interactionID: setup.id, for: punchLine.id)

        if !fetchedSetups.isEmpty {
            fetchedSetups.removeFirst()
        }
        fetchSetupBatchIfNeeded()

        let jokePostRequest = JokePostRequest(
            punchLineID: punchLine.id,
            punchLineDisplayName: punchLine.displayName,
            setup: setup.text,
            setupID: setup.id,
            setupAuthorID: setup.authorID,
            setupAuthorUsername: setup.authorUsername,
            punchline: enteredPunchlineText.trimTrailingWhiteSpace(),
            punchlineAuthorID: userInfo.punchLineUserID,
            punchlineAuthorUsername: userInfo.punchLineUsername
        )

        Task {
            await APIManager.post(joke: jokePostRequest)
        }

    }

    // MARK: Vote Methods

    func voteOnCurrentJoke(vote: JokeVote) {
        guard let joke = currentJoke else { return }

        AppSessionManager.addJoke(interactionID: joke.id, for: punchLine.id)

        if !fetchedJokes.isEmpty {
            fetchedJokes.removeFirst()
        }
        fetchJokeBatchIfNeeded()

        Task {
            await APIManager.voteOn(joke: joke, with: vote)
        }

    }

    func getTooFunnyReportsCount() -> Int {
        return AppSessionManager.userInfo?.todaysTooFunnyReportsCount ?? 0
    }

    func reportCurrentJoke(for reportReason: JokeReportReason) {
        guard let joke = currentJoke else { return }

        AppSessionManager.addJoke(interactionID: joke.id, for: punchLine.id)

        if !fetchedJokes.isEmpty {
            fetchedJokes.removeFirst()
        }
        fetchJokeBatchIfNeeded()

        if reportReason == .tooFunny {
            AppSessionManager.incrementTodaysTooFunnyReportsCount()
        }

        Task {
            await APIManager.report(joke: joke, for: reportReason)
        }

    }

}

enum PunchLineActivity {
    case setup, punchline, vote, somethingWentWrong
}

enum TaskType {
    case first, second, third, extra, training
}
