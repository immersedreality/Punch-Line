//
//  Joke.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import Foundation

struct Joke: Codable, Identifiable {

    let id: String
    let punchLineID: String
    let punchLineDisplayName: String

    let setup: String
    let setupAuthorID: String
    let setupAuthorUsername: String?

    let punchline: String
    let punchlineAuthorID: String
    let punchlineAuthorUsername: String?

    let haCount: Int
    let mehCount: Int
    let ughCount: Int
    let isTooFunnyCount: Int
    let isOffensiveCount: Int

    let dateCreated: Date
    let dayRanking: Int?

    var totalVoteCount: Double {
        return Double(haCount + mehCount + ughCount + (isTooFunnyCount * 2))
    }

    var totalUpvoteCount: Double {
        return Double(haCount + (isTooFunnyCount * 2))
    }

    var baseRankingScore: Double {
        let upVotePercentage = totalUpvoteCount / totalVoteCount
        let downVotePercentage = Double(ughCount) / totalVoteCount
        return upVotePercentage - downVotePercentage
    }

    var isOffensive: Bool {
        guard isOffensiveCount > 2 else { return false }
        let isOffensiveCountDouble = Double(isOffensiveCount)
        let totalPlusOffensiveFlagCount = isOffensiveCountDouble + totalVoteCount
        return (isOffensiveCountDouble / totalPlusOffensiveFlagCount) > 0.10
    }

}
