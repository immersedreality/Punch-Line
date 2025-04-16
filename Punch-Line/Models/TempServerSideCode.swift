//
//  TempServerSideCode.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/16/25.
//

//Joke

//let haCount: Int
//let mehCount: Int
//let ughCount: Int
//let isTooFunnyCount: Int
//let isOffensiveCount: Int
//
//var totalVoteCount: Double {
//    return Double(haCount + mehCount + ughCount + (isTooFunnyCount * 2))
//}
//
//var totalUpvoteCount: Double {
//    return Double(haCount + (isTooFunnyCount * 2))
//}
//
//var baseRankingScore: Double {
//    let upVotePercentage = totalUpvoteCount / totalVoteCount
//    let downVotePercentage = Double(ughCount) / totalVoteCount
//    return upVotePercentage - downVotePercentage
//}
//
//var isOffensive: Bool {
//    guard isOffensiveCount > 2 else { return false }
//    let isOffensiveCountDouble = Double(isOffensiveCount)
//    let totalPlusOffensiveFlagCount = isOffensiveCountDouble + totalVoteCount
//    return (isOffensiveCountDouble / totalPlusOffensiveFlagCount) > 0.10
//}

//Setup

//let totalInteractionsCount: Int
//let isUnfunnyCount: Int
//let isOffensiveCount: Int
//
//var isUnfunny: Bool {
//    guard totalInteractionsCount > 10 else { return false }
//    return (Double(isUnfunnyCount) / Double(totalInteractionsCount)) > 0.25
//}
//
//var isOffensive: Bool {
//    guard isOffensiveCount > 2 else { return false }
//    return (Double(isOffensiveCount) / Double(totalInteractionsCount)) > 0.10
//}
