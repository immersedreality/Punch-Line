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

    let id: String
    let dateCreated: Date = Date()

    let setup: String
    let setupAuthorID: String

    let punchline: String
    let punchlineAuthorID: String
    
    let haCount: Int
    let mehCount: Int
    let ughCount: Int
    let isTooFunnyCount: Int
    let isOffensiveCount: Int
    let favoritedCount: Int

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
        let isOffensiveCountDouble = Double(isOffensiveCount)
        let totalPlusOffensiveFlagCount = isOffensiveCountDouble + totalVoteCount
        return (isOffensiveCountDouble / totalPlusOffensiveFlagCount) > 0.10
    }

}

enum JokeRecordKeys: String {
    case type = "Joke"
}

extension Joke {
    var record: CKRecord {
        let record = CKRecord(recordType: JokeRecordKeys.type.rawValue)
        return record
    }
}
