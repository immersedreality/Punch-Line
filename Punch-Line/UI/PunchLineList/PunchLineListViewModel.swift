//
//  PunchLineListViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation

class PunchLineListViewModel {

    var publicPunchLineLaunchers: [PunchLineLauncher] {
        get {
            return AppSessionManager.currentPublicPunchlineLaunchers
        }
    }
    var ownedCustomPunchlineLaunchers: [PunchLineLauncher] = []
    var joinedCustomPunchlineLaunchers: [PunchLineLauncher] = []

    var selectedPunchLineLauncher: PunchLineLauncher?
    var punchlineToLaunch: PunchLine?

    var fetchedSetups: [Setup] = []
    var fetchedJokes: [Joke] = []

    var setUpToLaunchWith: Setup?
    var jokeToLaunchWith: Joke?

    func fetchCustomPunchlineLaunchers() async {
        ownedCustomPunchlineLaunchers = await CloudKitManager.getOwnedCustomPunchLineLaunchers()
        joinedCustomPunchlineLaunchers = await CloudKitManager.getJoinedCustomPunchLineLaunchers()
    }

    func generatePublicPunchLineToLaunch() async {
        guard let launcher = selectedPunchLineLauncher else { return }

        let allPunchLinesForLauncher = await CloudKitManager.getPunchLines(for: launcher)

        guard !allPunchLinesForLauncher.isEmpty else {
            let newPunchLine = await CloudKitManager.createNewPublicPunchLine(for: launcher)
            punchlineToLaunch = newPunchLine
            return
        }

        punchlineToLaunch = allPunchLinesForLauncher.first { punchLine in
            CloudKitManager.getItemCount(for: punchLine) <= 750
        } as? PublicPunchLine
    }

    func generateCustomPunchLineToLaunch() -> CustomPunchLine? {
        return nil
    }

    func getARandomSetup() async {
        guard let punchlineToLaunch = punchlineToLaunch else { return }
        fetchedSetups = await CloudKitManager.getSetups(for: punchlineToLaunch)
        guard !fetchedSetups.isEmpty else { return }

        let randomIndex = Int.random(in: 0..<fetchedSetups.count)
        setUpToLaunchWith = fetchedSetups.remove(at: randomIndex)
    }

    func getARandomJoke() async {
        guard let punchlineToLaunch = punchlineToLaunch else { return }
        fetchedJokes = await CloudKitManager.getJokes(for: punchlineToLaunch)
        guard !fetchedJokes.isEmpty else { return }

        let randomIndex = Int.random(in: 0..<fetchedJokes.count)
        jokeToLaunchWith = fetchedJokes.remove(at: randomIndex)
    }

}
