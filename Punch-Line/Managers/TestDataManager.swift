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

    static let testDataIndexRange = 0...19
    static var testPunchLines: [PunchLine] = []
    static var testJokeHistoryEntryGroups: [String: [JokeHistoryEntryGroup]] = [:]
    static var testYearCount = 1
    static var testMonthCount = 1

    class func initializeTestData() {
        initializeTestPunchLines()
        testPunchLines.forEach { initializeTestJokeHistoryEntryGroups(for: $0.id) }
    }

    private class func initializeTestPunchLines() {

        let globalPunchLine = PunchLine(
            id: UUID().uuidString,
            displayName: "United States",
            owningUserID: nil,
            participantUserIDs: nil,
            scope: .regional,
            lastDailyResetDate: Date()
        )
        testPunchLines.append(globalPunchLine)

        let newYorkCityPunchLine = PunchLine(
            id: UUID().uuidString,
            displayName: "New York City",
            owningUserID: nil,
            participantUserIDs: nil,
            scope: .regional,
            lastDailyResetDate: Date()
        )
        testPunchLines.append(newYorkCityPunchLine)

        let moviesPunchLine = PunchLine(
            id: UUID().uuidString,
            displayName: "Movies",
            owningUserID: nil,
            participantUserIDs: nil,
            scope: .topical,
            lastDailyResetDate: Date()
        )
        testPunchLines.append(moviesPunchLine)

        let videoGamesPunchLine = PunchLine(
            id: UUID().uuidString,
            displayName: "Video Games",
            owningUserID: nil,
            participantUserIDs: nil,
            scope: .topical,
            lastDailyResetDate: Date()
        )
        testPunchLines.append(videoGamesPunchLine)

    }

    private class func initializeTestJokeHistoryEntryGroups(for punchLineID: String) {
        guard let startingDate = DateComponents(calendar: .current, year: 2024, month: 1, day: 1).date else { return }
        let currentDate = Date()

        // Calculate Date Range

        var iteratingDate = startingDate
        var dateRange: [Date] = []

        while iteratingDate <= currentDate {
            dateRange.append(iteratingDate)
            iteratingDate = Calendar.current.date(byAdding: .day, value: 1, to: iteratingDate) ?? Date()
        }

        dateRange.removeLast()

        // Form JokeHistoryEntryGroups

        var jokeHistoryEntryGroups: [JokeHistoryEntryGroup] = []
        var currentEntryGroupID = UUID().uuidString
        var currentJokeHistoryEntryBatch: [JokeHistoryEntry] = []
        var yearIterator = Calendar.current.component(.year, from: startingDate)
        var monthIterator = Calendar.current.component(.month, from: startingDate)

        for date in dateRange {

            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)

            if year == yearIterator && month == monthIterator {
                currentJokeHistoryEntryBatch.append(JokeHistoryEntry(id: UUID().uuidString, entryGroupID: currentEntryGroupID, punchLineID: punchLineID, date: date, jokes: getRandomJokes(for: punchLineID)))
                if date == dateRange.last {
                    currentJokeHistoryEntryBatch.reverse()

                    let jokeHistoryEntryGroup = JokeHistoryEntryGroup(
                        id: UUID().uuidString,
                        punchLineID: punchLineID,
                        year: year,
                        month: month,
                        entries: currentJokeHistoryEntryBatch
                    )

                    jokeHistoryEntryGroups.append(jokeHistoryEntryGroup)
                }
            } else if year == yearIterator && month != monthIterator {
                currentJokeHistoryEntryBatch.reverse()

                let jokeHistoryEntryGroup = JokeHistoryEntryGroup(
                    id: UUID().uuidString,
                    punchLineID: punchLineID,
                    year: year,
                    month: month - 1,
                    entries: currentJokeHistoryEntryBatch
                )

                jokeHistoryEntryGroups.append(jokeHistoryEntryGroup)

                currentJokeHistoryEntryBatch = []
                monthIterator = month
                testMonthCount += 1

                currentJokeHistoryEntryBatch.append(JokeHistoryEntry(id: UUID().uuidString, entryGroupID: currentEntryGroupID, punchLineID: punchLineID, date: date, jokes: getRandomJokes(for: punchLineID)))
                if date == dateRange.last {
                    currentJokeHistoryEntryBatch.reverse()

                    let jokeHistoryEntryGroup = JokeHistoryEntryGroup(
                        id: UUID().uuidString,
                        punchLineID: punchLineID,
                        year: year,
                        month: month,
                        entries: currentJokeHistoryEntryBatch
                    )

                    jokeHistoryEntryGroups.append(jokeHistoryEntryGroup)
                }
            } else {
                currentJokeHistoryEntryBatch.reverse()

                let jokeHistoryEntryGroup = JokeHistoryEntryGroup(
                    id: currentEntryGroupID,
                    punchLineID: punchLineID,
                    year: year - 1,
                    month: 12,
                    entries: currentJokeHistoryEntryBatch
                )

                jokeHistoryEntryGroups.append(jokeHistoryEntryGroup)

                currentEntryGroupID = UUID().uuidString
                currentJokeHistoryEntryBatch = []
                yearIterator = year
                monthIterator = month
                testYearCount += 1

                currentJokeHistoryEntryBatch.append(JokeHistoryEntry(id: UUID().uuidString, entryGroupID: currentEntryGroupID, punchLineID: punchLineID, date: date, jokes: getRandomJokes(for: punchLineID)))
                if date == dateRange.last {
                    currentJokeHistoryEntryBatch.reverse()

                    let jokeHistoryEntryGroup = JokeHistoryEntryGroup(
                        id: UUID().uuidString,
                        punchLineID: punchLineID,
                        year: year,
                        month: month,
                        entries: currentJokeHistoryEntryBatch
                    )

                    jokeHistoryEntryGroups.append(jokeHistoryEntryGroup)
                }
            }

        }

        jokeHistoryEntryGroups.reverse()
        self.testJokeHistoryEntryGroups[punchLineID] = jokeHistoryEntryGroups
    }

    class func getRandomJokeHistoryEntries(for punchLineID: String) -> [JokeHistoryEntry] {
        guard let startingDate = DateComponents(calendar: .current, year: 2025, month: 1, day: 1).date else { return [] }
        let currentDate = Date()

        // Calculate Date Range

        var iteratingDate = startingDate
        var dateRange: [Date] = []

        while iteratingDate <= currentDate {
            dateRange.append(iteratingDate)
            iteratingDate = Calendar.current.date(byAdding: .day, value: 1, to: iteratingDate) ?? Date()
        }

        dateRange.removeLast()

        let currentEntryGroupID = UUID().uuidString
        var currentJokeHistoryEntryBatch: [JokeHistoryEntry] = []

        for date in dateRange {
            currentJokeHistoryEntryBatch.append(JokeHistoryEntry(id: UUID().uuidString, entryGroupID: currentEntryGroupID, punchLineID: punchLineID, date: date, jokes: getRandomJokes(for: punchLineID)))
        }

        currentJokeHistoryEntryBatch.reverse()

        return currentJokeHistoryEntryBatch
    }

    class func getRandomJokes(for punchLineID: String) -> [Joke] {

        var randomJokes: [Joke] = []

        for rank in 0...9 {
            let randomSetup = testSetUps[Int.random(in: testDataIndexRange)]
            let randomPunchline = testPunchlines[Int.random(in: testDataIndexRange)]

            let randomJoke = Joke(
                id: UUID().uuidString,
                punchLineID: punchLineID,
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

    private class func getRandomName() -> String? {
        if Int.random(in: 0...1) == 1 {
            return testUsernames[Int.random(in: testDataIndexRange)]
        } else {
            return nil
        }
    }

}
