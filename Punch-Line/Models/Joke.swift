//
//  Joke.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import RealmSwift

class Joke: Object {

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var dateCreated: Date = Date()

    @objc dynamic var setup: String = ""
    @objc dynamic var setupAuthor: String = ""

    @objc dynamic var punchline: String = ""
    @objc dynamic var punchlineAuthor: String = ""
    
    @objc dynamic var haCount: Int = 0
    @objc dynamic var mehCount: Int = 0
    @objc dynamic var ughCount: Int = 0
    @objc dynamic var isTooFunnyCount: Int = 0
    @objc dynamic var isOffensiveCount: Int = 0

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

    override class func primaryKey() -> String? {
        return PrimaryKeys.id
    }

    override class func ignoredProperties() -> [String] {
        return [
            IgnoredProperties.totalVoteCount,
            IgnoredProperties.totalUpvoteCount,
            IgnoredProperties.baseRankingScore,
            IgnoredProperties.isOffensive
        ]
    }

}
