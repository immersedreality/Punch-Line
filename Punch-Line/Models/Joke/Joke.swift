//
//  Joke.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

struct Joke {

    let cloudKitID: CKRecord.ID
    let owningPunchLine: CKRecord.Reference

    let setup: String
    let setupAuthor: String

    let punchline: String
    let punchlineAuthor: String
    
    let haCount: Int
    let mehCount: Int
    let ughCount: Int
    let isTooFunnyCount: Int
    let isOffensiveCount: Int

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

struct JokeRecordKeys {
    static let type = "Joke"
    static let owningPunchLine = "owningPunchLine"
    static let setup = "setup"
    static let setupAuthor = "setupAuthor"
    static let punchline = "punchline"
    static let punchlineAuthor = "punchlineAuthor"
    static let haCount = "haCount"
    static let mehCount = "mehCount"
    static let ughCount = "ughCount"
    static let isTooFunnyCount = "isTooFunnyCount"
    static let isOffensiveCount = "isOffensiveCount"
}
