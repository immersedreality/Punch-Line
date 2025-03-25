//
//  TestDataManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import Foundation

final class TestDataManager {

    static let testSetUps = [
        "Why did the chicken suck the chode?",
        "Yo, what the heck is that all about my man?",
        "What do you call a newspaper bent backward?",
        "Hows about this and that and the other thing...",
        "Poop man go what?  He what what what?",
        "What are we going to do without men?",
        "If you go over to the bank, what is going to be over there?",
        "A man, a woman, and thirty-five guys walk into a bar...",
        "What happened to the bank man who farted and then said 'Uh Oh'?",
        "Farting isn't cool and a million other farts agree.  Do you?"
    ]

    static let testPunchlines = [
        "That's just how it be, my man.",
        "Something about the smell and also the other smell.",
        "Whooop, there it is!",
        "Film school is for films and for school.",
        "Cryptocurrency is fun and so is fun.",
        "The internet is for fun and is also for more fun.",
        "I can see through windows because I have talent.",
        "Maybe just because, you know.  Maybe just because.",
        "People are people, too.  People, especially.",
        "No one likes pooping except for the really big poopers."
    ]

    class func getRandomJoke() -> Joke {
        let randomSetup = testSetUps[Int.random(in: 0...9)]
        let randomPunchline = testPunchlines[Int.random(in: 0...9)]

        let randomJoke = Joke(
            punchLineID: UUID().uuidString,
            setup: randomSetup,
            setupAuthorID: UUID().uuidString,
            setupAuthorUsername: nil,
            punchline: randomPunchline,
            punchlineAuthorID: UUID().uuidString,
            punchlineAuthorUsername: nil,
            haCount: 0,
            mehCount: 0,
            ughCount: 0,
            isTooFunnyCount: 0,
            isOffensiveCount: 0
        )

        return randomJoke
    }

}
