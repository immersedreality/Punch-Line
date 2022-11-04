//
//  ActivityFeedViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

class ActivityFeedViewModel {

    private let punchLine: PunchLine
    private var currentSetup: Setup?
    private var currentJoke: Joke?

    init(punchLine: PunchLine) {
        self.punchLine = punchLine
    }

    func getPunchlineStringIdentifier() -> String {
        return punchLine.cloudKitID.recordName
    }

    func setCurrent(setup: Setup) {
        currentSetup = setup
    }

    func getCurrentSetup() -> Setup? {
        return currentSetup
    }

    func setCurrent(joke: Joke) {
        currentJoke = joke
    }

    func getCurrentJoke() -> Joke? {
        return currentJoke
    }

    func clearCurrentValues() {
        currentSetup = nil
        currentJoke = nil
    }

    func addSetupToPunchLine(text: String) async {
        await CloudKitManager.addSetup(to: punchLine, setup: text, author: AppSessionManager.userInfo?.username ?? "Tim Allen")
    }

    func getARandomSetup() async {
        currentSetup = await CloudKitManager.getRandomSetup(from: punchLine)
    }

    func flagSetup(as flag: SetupFlag) async {
        switch flag {
        case .unfunny:
            guard let setup = currentSetup else { return }
            let updatedSetup = Setup(
                cloudKitID: setup.cloudKitID,
                owningPunchLine: setup.owningPunchLine,
                text: setup.text,
                author: setup.author,
                isUnfunnyCount: setup.isUnfunnyCount + 1,
                isOffensiveCount: setup.isOffensiveCount
            )
            await CloudKitManager.update(setup: updatedSetup, in: punchLine)
        case .offensive:
            guard let setup = currentSetup else { return }
            let updatedSetup = Setup(
                cloudKitID: setup.cloudKitID,
                owningPunchLine: setup.owningPunchLine,
                text: setup.text,
                author: setup.author,
                isUnfunnyCount: setup.isUnfunnyCount,
                isOffensiveCount: setup.isOffensiveCount + 1
            )
            await CloudKitManager.update(setup: updatedSetup, in: punchLine)
        }
    }

    func addJokeToPunchLine(text: String) async {
        await CloudKitManager.addJoke(
            to: punchLine,
            setup: currentSetup?.text ?? "",
            setupAuthor: currentSetup?.author ?? "Tim Allen",
            punchline: text,
            punchlineAuthor: AppSessionManager.userInfo?.username ?? "Tim Allen"
        )
    }

    func getARandomJoke() async {
        currentJoke = await CloudKitManager.getRandomJoke(from: punchLine)
    }

    func voteOnJoke(vote: JokeVote) async {
        switch vote {
        case .ha:
            guard let joke = currentJoke else { return }
            let updatedJoke = Joke(
                cloudKitID: joke.cloudKitID,
                owningPunchLine: joke.owningPunchLine,
                setup: joke.setup,
                setupAuthor: joke.setupAuthor,
                punchline: joke.punchline,
                punchlineAuthor: joke.punchlineAuthor,
                haCount: joke.haCount + 1,
                mehCount: joke.mehCount,
                ughCount: joke.ughCount,
                isTooFunnyCount: joke.isTooFunnyCount,
                isOffensiveCount: joke.isOffensiveCount
            )
            await CloudKitManager.update(joke: updatedJoke, in: punchLine)
        case .meh:
            guard let joke = currentJoke else { return }
            let updatedJoke = Joke(
                cloudKitID: joke.cloudKitID,
                owningPunchLine: joke.owningPunchLine,
                setup: joke.setup,
                setupAuthor: joke.setupAuthor,
                punchline: joke.punchline,
                punchlineAuthor: joke.punchlineAuthor,
                haCount: joke.haCount,
                mehCount: joke.mehCount + 1,
                ughCount: joke.ughCount,
                isTooFunnyCount: joke.isTooFunnyCount,
                isOffensiveCount: joke.isOffensiveCount
            )
            await CloudKitManager.update(joke: updatedJoke, in: punchLine)
        case .ugh:
            guard let joke = currentJoke else { return }
            let updatedJoke = Joke(
                cloudKitID: joke.cloudKitID,
                owningPunchLine: joke.owningPunchLine,
                setup: joke.setup,
                setupAuthor: joke.setupAuthor,
                punchline: joke.punchline,
                punchlineAuthor: joke.punchlineAuthor,
                haCount: joke.haCount,
                mehCount: joke.mehCount,
                ughCount: joke.ughCount + 1,
                isTooFunnyCount: joke.isTooFunnyCount,
                isOffensiveCount: joke.isOffensiveCount
            )
            await CloudKitManager.update(joke: updatedJoke, in: punchLine)
        }
    }

    func flagJoke(as flag: JokeFlag) async {
        switch flag {
        case .tooFunny:
            guard let joke = currentJoke else { return }
            let updatedJoke = Joke(
                cloudKitID: joke.cloudKitID,
                owningPunchLine: joke.owningPunchLine,
                setup: joke.setup,
                setupAuthor: joke.setupAuthor,
                punchline: joke.punchline,
                punchlineAuthor: joke.punchlineAuthor,
                haCount: joke.haCount,
                mehCount: joke.mehCount,
                ughCount: joke.ughCount,
                isTooFunnyCount: joke.isTooFunnyCount + 1,
                isOffensiveCount: joke.isOffensiveCount
            )
            await CloudKitManager.update(joke: updatedJoke, in: punchLine)
        case .offensive:
            guard let joke = currentJoke else { return }
            let updatedJoke = Joke(
                cloudKitID: joke.cloudKitID,
                owningPunchLine: joke.owningPunchLine,
                setup: joke.setup,
                setupAuthor: joke.setupAuthor,
                punchline: joke.punchline,
                punchlineAuthor: joke.punchlineAuthor,
                haCount: joke.haCount,
                mehCount: joke.mehCount,
                ughCount: joke.ughCount,
                isTooFunnyCount: joke.isTooFunnyCount,
                isOffensiveCount: joke.isOffensiveCount + 1
            )
            await CloudKitManager.update(joke: updatedJoke, in: punchLine)
        }
    }

}

enum SetupFlag {
    case unfunny, offensive
}

enum JokeVote {
    case ha, meh, ugh
}

enum JokeFlag {
    case tooFunny, offensive
}
