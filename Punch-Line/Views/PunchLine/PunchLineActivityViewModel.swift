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

    var currentSetup: Setup?
    var currentJoke: Joke?

    init(punchLine: any ActivePunchLine, activity: PunchLineActivity, activityDisplayText: String) {
        self.punchLine = punchLine
        self.activity = activity
        self.activityDisplayText = activityDisplayText
        fetchSetupBatch()
        fetchJokeBatch()
    }

    // MARK: Data Fetchers

    func fetchSetupBatch() {
        Task {
            let newSetups = await APIManager.getSetups()
            fetchedSetups.append(contentsOf: newSetups)
        }
    }

    func fetchJokeBatch() {
        Task {
            let newJokes = await APIManager.getJokes()
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

        guard let todaysTaskCount = AppSessionManager.userInfo?.todaysTaskCounts[punchLine.id] else {
            activity = .somethingWentWrong
            activityDisplayText = ""
            currentSetup = nil
            currentJoke = nil
            return
        }

        switch todaysTaskCount {
        case 0:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupFirst
            currentSetup = nil
            currentJoke = nil
        case 1:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupSecond
            currentSetup = nil
            currentJoke = nil
        case 2:
            activity = .setup
            activityDisplayText = ActivityFeedMessages.setupThird
            currentSetup = nil
            currentJoke = nil
        case 3, 5, 8, 12, 17, 23, 30, 38, 47, 57:
            activity = .punchline
            activityDisplayText = ActivityFeedMessages.punchline
            currentSetup = fetchedSetups.first
            currentJoke = nil
        default:
            activity = .vote
            activityDisplayText = ActivityFeedMessages.vote
            currentJoke = fetchedJokes.first
            currentSetup = nil
        }

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

    // MARK: Setup Methods

    func createNewSetup() {
        guard let userInfo = AppSessionManager.userInfo else { return }
        let setupPostRequest = SetupPostRequest(
            punchLineID: punchLine.id,
            text: enteredSetupText,
            authorID: userInfo.punchLineUserID,
            authorUsername: userInfo.punchLineUserName
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
            setupAuthorID: setup.authorID,
            setupAuthorUsername: setup.authorUsername,
            punchline: enteredPunchlineText,
            punchlineAuthorID: userInfo.punchLineUserID,
            punchlineAuthorUsername: userInfo.punchLineUserName,
            dateCreated: Date()
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
