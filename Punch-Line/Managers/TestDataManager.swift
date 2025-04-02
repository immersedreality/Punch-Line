//
//  TestDataManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import Foundation

final class TestDataManager {

    static var testDateDisplayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: Date())
    }
    
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
        "Farting isn't cool and a million other farts agree.  Do you?",
        "What do you get when you mix two cake mixes into three cake mixes?",
        "A man holding a doughnut hole walks into a bar...",
        "Five children, three other children, and Tina Turner take turns farting...",
        "If America is cream cheese, then what is Canada?",
        "How many walruses does it take to screw in a lightbulb?",
        "What do you call a high-five performed undersea?",
        "I'm trying to figure out what genre of music screaming children is...",
        "I'm jealous of shameless people's ability to just go to the doctor...",
        "Why did the ice cream man have a sideways boner?",
        "What movie can dolphins not stop watching?"
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
        "No one likes pooping except for the really big poopers.",
        "Disney's FernGully™",
        "The Lord works in mysterious ways, and sometimes not at all.",
        "Because AMERICA!",
        "Our civil liberties and quality of life are rapidly declining (in a funny way).",
        "Publish or perish.",
        "Something weird as shit and you should be embarrassed by.",
        "Chloë Sevigny has done some weird stuff on camera.",
        "ART out of TEN.",
        "I don't know, but I'm gonna have sex with it.",
        "I was born too late to explore the world and too early to see what Lunchables™ will do next!"
    ]

    static let testUsernames = [
        "Tim Allen",
        "Ingmar Bergman",
        "Jeremy Piven",
        "Federico Fellini",
        "Sigourney Weaver",
        "Timothy Allens",
        "A$AP Rocky",
        "Robert Bresson",
        "George Clooney",
        "Josh Incredible",
        "Tina Turner",
        "Diana Ross",
        "Werner Herzog",
        "Richard D. Games",
        "Sylvester Stallone",
        "Rumpelstiltskin",
        "Timothy Chalomet",
        "Chantal Akerman",
        "Jeanne Dielmann",
        "Job From The Bible"
    ]

    static let testIndexRange = 0...19

    class func getTestJokeHistoryEntries() -> [JokeHistoryEntry] {
        guard let startDate = DateComponents(calendar: .current, year: 2025, month: 4, day: 1).date else { return [] }
        let days = (Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0) - 1

        var jokeHistoryEntries: [JokeHistoryEntry] = []

        (0...days).forEach { dayIndex in
            guard let date = Calendar.current.date(byAdding: .day, value: dayIndex, to: startDate) else { return }
            jokeHistoryEntries.append(JokeHistoryEntry(id: UUID().uuidString, punchLineID: UUID().uuidString, date: date, jokes: getRandomJokes()))
        }

        jokeHistoryEntries.reverse()
        
        return jokeHistoryEntries
    }

    class func getRandomJokes() -> [Joke] {

        var randomJokes: [Joke] = []

        for rank in 0...9 {
            let randomSetup = testSetUps[Int.random(in: testIndexRange)]
            let randomPunchline = testPunchlines[Int.random(in: testIndexRange)]

            let randomJoke = Joke(
                id: UUID().uuidString,
                punchLineID: UUID().uuidString,
                setup: randomSetup,
                setupAuthorID: UUID().uuidString,
                setupAuthorUsername: getRandomName(),
                punchline: randomPunchline,
                punchlineAuthorID: UUID().uuidString,
                punchlineAuthorUsername: getRandomName(),
                haCount: 0,
                mehCount: 0,
                ughCount: 0,
                isTooFunnyCount: 0,
                isOffensiveCount: 0,
                dayRanking: rank + 1
            )

            randomJokes.append(randomJoke)
        }

        return randomJokes
    }

    class func getRandomName() -> String? {
        if Int.random(in: 0...1) == 1 {
            return testUsernames[Int.random(in: testIndexRange)]
        } else {
            return nil
        }
    }

}
