//
//  MockDataManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import Foundation

final class MockDataManager {

    // MARK: Test Data

    static let testPunchLineDisplayNames = [
        "United States",
        "New York City",
        "Florida",
        "Ohio",
        "Guatamala",
        "France",
        "Glorious Nippon",
        "Movies",
        "Television",
        "Music",
        "Video Games",
        "Board Games",
        "Tim's Custom Punch-Line",
        "All About Tim Allen",
        "Politics",
        "Public Transportation",
        "Vinyl",
        "Whining About Reddit",
        "Books",
        "Russia"
    ]

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
    static var tempMockPrivatePunchLine: PrivatePunchLine?

    // MARK: SwiftUI Preview Data

    static var testDateDisplayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: Date())
    }

    // MARK: Mock Data Methods

    class func getMockJokeHistoryEntries(for entryGroup: JokeHistoryEntryGroup) -> [JokeHistoryEntry] {

        let dateComponents = DateComponents(year: entryGroup.year, month: entryGroup.month)
        guard let startingDate = Calendar.current.date(from: dateComponents) else { return [] }
        guard let range = Calendar.current.range(of: .day, in: .month, for: startingDate) else { return [] }
        var iteratingDate = startingDate
        var dateRange: [Date] = []

        for _ in range {
            dateRange.append(iteratingDate)
            iteratingDate = Calendar.current.date(byAdding: .day, value: 1, to: iteratingDate) ?? Date()
        }

        var jokeHistoryEntries: [JokeHistoryEntry] = []

        for date in dateRange {
            jokeHistoryEntries.append(
                JokeHistoryEntry(id: UUID().uuidString, entryGroupID: entryGroup.id, date: date, jokes: getMockOrPreviewHistoryJokeBatch(for: entryGroup.punchLineID, numberOfJokes: 10))
            )
        }

        jokeHistoryEntries.reverse()
        
        return jokeHistoryEntries
        
    }

    class func getMockSearchResults(for searchString: String) -> [HistoryJoke] {

        var searchResults: [HistoryJoke] = []

        for _ in 0...49 {
            guard let startingDate = DateComponents(calendar: .current, year: 2024, month: 1, day: 1).date else { continue }
            let randomPunchLineDisplayName = testPunchLineDisplayNames[Int.random(in: testDataIndexRange)]
            let randomRank = Int.random(in: 1...10)

            let fakeSearchResult = HistoryJoke(
                id: UUID().uuidString,
                entryID: UUID().uuidString,
                punchLineDisplayName: randomPunchLineDisplayName,
                setup: "A setup that might have '\(searchString)' in it.",
                setupAuthorID: UUID().uuidString,
                setupAuthorUsername: getRandomName(),
                punchline: "A punchline that might have '\(searchString)' in it.",
                punchlineAuthorID: UUID().uuidString,
                punchlineAuthorUsername: getRandomName(),
                dateCreated: Date.randomBetween(start: startingDate, end: Date()),
                dayRanking: randomRank,
                isOffensive: false
            )

            searchResults.append(fakeSearchResult)
        }

        return searchResults
    }

    class func getMockSetup() -> Setup {
        let randomSetup = testSetUps[Int.random(in: testDataIndexRange)]

        let mockSetup = Setup(
            id: UUID().uuidString,
            punchLineID: UUID().uuidString,
            text: randomSetup,
            authorID: UUID().uuidString,
            authorUsername: getRandomName(),
            dateCreated: Date(),
            isOffensive: false
        )

        return mockSetup
    }

    class func getMockSetupBatch() -> [Setup] {
        var mockSetups: [Setup] = []

        for _ in 0...49 {
            mockSetups.append(getMockSetup())
        }

        return mockSetups
    }

    class func getMockJoke() -> Joke {
        let randomSetup = testSetUps[Int.random(in: testDataIndexRange)]
        let randomPunchline = testPunchlines[Int.random(in: testDataIndexRange)]
        let randomPunchLineDisplayName = testPunchLineDisplayNames[Int.random(in: testDataIndexRange)]

        let mockJoke = Joke(
            id: UUID().uuidString,
            punchLineID: UUID().uuidString,
            punchLineDisplayName: randomPunchLineDisplayName,
            setup: randomSetup,
            setupID: UUID().uuidString,
            setupAuthorID: UUID().uuidString,
            setupAuthorUsername: getRandomName(),
            punchline: randomPunchline,
            punchlineAuthorID: UUID().uuidString,
            punchlineAuthorUsername: getRandomName(),
            dateCreated: Date(),
            isOffensive: false
        )

        return mockJoke
    }

    class func getMockOrPreviewJokeBatch(for punchLineID: String = UUID().uuidString, numberOfJokes: Int) -> [Joke] {

        var randomJokes: [Joke] = []

        for _ in 1...numberOfJokes {
            let randomSetup = testSetUps[Int.random(in: testDataIndexRange)]
            let randomPunchline = testPunchlines[Int.random(in: testDataIndexRange)]
            var punchLineDisplayName = getPreviewPublicPunchLines().first(where: { $0.id == punchLineID })?.displayName ?? ""
            if punchLineDisplayName.isEmpty {
                punchLineDisplayName = testPunchLineDisplayNames[Int.random(in: testDataIndexRange)]
            }

            let randomJoke = Joke(
                id: UUID().uuidString,
                punchLineID: punchLineID,
                punchLineDisplayName: punchLineDisplayName,
                setup: randomSetup,
                setupID: UUID().uuidString,
                setupAuthorID: UUID().uuidString,
                setupAuthorUsername: getRandomName(),
                punchline: randomPunchline,
                punchlineAuthorID: UUID().uuidString,
                punchlineAuthorUsername: getRandomName(),
                dateCreated: Date(),
                isOffensive: false
            )

            randomJokes.append(randomJoke)
        }

        return randomJokes
    }

    class func getMockOrPreviewHistoryJokeBatch(for punchLineID: String = UUID().uuidString, numberOfJokes: Int) -> [HistoryJoke] {

        var randomJokes: [HistoryJoke] = []

        for rank in 1...numberOfJokes {
            let randomSetup = testSetUps[Int.random(in: testDataIndexRange)]
            let randomPunchline = testPunchlines[Int.random(in: testDataIndexRange)]
            var punchLineDisplayName = getPreviewPublicPunchLines().first(where: { $0.id == punchLineID })?.displayName ?? ""
            if punchLineDisplayName.isEmpty {
                punchLineDisplayName = testPunchLineDisplayNames[Int.random(in: testDataIndexRange)]
            }

            let randomJoke = HistoryJoke(
                id: UUID().uuidString,
                entryID: UUID().uuidString,
                punchLineDisplayName: punchLineDisplayName,
                setup: randomSetup,
                setupAuthorID: UUID().uuidString,
                setupAuthorUsername: getRandomName(),
                punchline: randomPunchline,
                punchlineAuthorID: UUID().uuidString,
                punchlineAuthorUsername: getRandomName(),
                dateCreated: Date(),
                dayRanking: rank,
                isOffensive: false
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

    class func createMockPrivatePunchLine(with request: PrivatePunchLinePostRequest) -> PrivatePunchLine {
        let mockPrivatePunchLine = PrivatePunchLine(
            id: UUID().uuidString,
            displayName: request.displayName,
            joinCode: "ABCDEF",
            owningUserID: request.owningUserID,
            owningUsername: request.owningUsername,
            lastDailyResetDate: Date()
        )

        tempMockPrivatePunchLine = mockPrivatePunchLine

        return mockPrivatePunchLine
    }

    // MARK: SwiftUI Preview Methods

    class func getPreviewPublicPunchLines() -> [PublicPunchLine] {
        guard let data = APIManager.fetchLocalMockJSONFile(fileName: MockRequestTitles.getPublicPunchLines) else {
            return []
        }
        guard let fetchedPublicPunchLines: [PublicPunchLine] = APIManager.decodeJSON(from: data) else {
            return []
        }
        return fetchedPublicPunchLines
    }

    class func getPreviewPrivatePunchLines() -> [PrivatePunchLine] {
        guard let data = APIManager.fetchLocalMockJSONFile(fileName: MockRequestTitles.getPrivatePunchLines) else {
            return []
        }
        guard let fetchedPrivatePunchLines: [PrivatePunchLine] = APIManager.decodeJSON(from: data) else {
            return []
        }
        return fetchedPrivatePunchLines
    }

    class func getPreviewJokeHistoryEntryGroups() -> [JokeHistoryEntryGroup] {
        guard let data = APIManager.fetchLocalMockJSONFile(fileName: MockRequestTitles.getEntryGroups) else {
            return []
        }
        guard let fetchedEntryGroups: [JokeHistoryEntryGroup] = APIManager.decodeJSON(from: data) else {
            return []
        }
        return fetchedEntryGroups
    }

    class func getPreviewJokeHistoryEntries() -> [JokeHistoryEntry] {

        guard let startingDate = DateComponents(calendar: .current, year: 2025, month: 1, day: 1).date else { return [] }
        let currentDate = Date()

        var iteratingDate = startingDate
        var dateRange: [Date] = []

        while iteratingDate <= currentDate {
            dateRange.append(iteratingDate)
            iteratingDate = Calendar.current.date(byAdding: .day, value: 1, to: iteratingDate) ?? Date()
        }

        dateRange.removeLast()

        let punchLineID = UUID().uuidString
        let currentEntryGroupID = UUID().uuidString
        var currentJokeHistoryEntryBatch: [JokeHistoryEntry] = []

        for date in dateRange {
            currentJokeHistoryEntryBatch.append(
                JokeHistoryEntry(id: UUID().uuidString, entryGroupID: currentEntryGroupID, date: date, jokes: getMockOrPreviewHistoryJokeBatch(for: punchLineID, numberOfJokes: 10))
            )
        }

        currentJokeHistoryEntryBatch.reverse()

        return currentJokeHistoryEntryBatch

    }

}
