//
//  APIManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/16/25.
//

import Foundation

final class APIManager {

    // MARK: Network Environment

    static let networkEnvironment: NetworkEnvironment = .dev

    // MARK: Punch-Lines

    class func getPublicPunchLines() async -> [PublicPunchLine] {
        if APIManager.networkEnvironment == .mock {
            guard let data = fetchLocalMockJSONFile(fileName: MockRequestTitles.getPublicPunchLines) else {
                return []
            }
            guard let fetchedPublicPunchLines: [PublicPunchLine] = decodeJSON(from: data) else {
                return []
            }
            return fetchedPublicPunchLines
        } else {
            guard let publicPunchLines: [PublicPunchLine] = await handleURLRequest(for: .getPublicPunchLines) else { return [] }
            return publicPunchLines
        }
    }

    class func getPrivatePunchLines(with ids: [String]) async -> [PrivatePunchLine] {
        if APIManager.networkEnvironment == .mock {
            guard let data = fetchLocalMockJSONFile(fileName: MockRequestTitles.getPrivatePunchLines) else {
                return []
            }
            guard let fetchedPrivatePunchLines: [PrivatePunchLine] = decodeJSON(from: data) else {
                return []
            }

            var filteredPunchLines = fetchedPrivatePunchLines.filter { ids.contains($0.id) }

            if let mockPrivatePunchLine = MockDataManager.tempMockPrivatePunchLine {
                filteredPunchLines.append(mockPrivatePunchLine)
            }

            return filteredPunchLines
        } else {
            guard let privatePunchLines: [PrivatePunchLine] = await handleURLRequest(for: .getPrivatePunchLinesWithIDs(punchLineIDs: ids)) else { return [] }

            for localPunchLine in AppSessionManager.userInfo?.joinedPrivatePunchLines ?? [] {
                if privatePunchLines.contains(where: { privatePunchLine in
                    localPunchLine.id == privatePunchLine.id
                }) == false {
                    AppSessionManager.removeJoinedPrivatePunchLine(with: localPunchLine.id)
                }
            }

            return privatePunchLines
        }
    }

    class func getPrivatePunchLine(with joinCode: String) async -> PrivatePunchLine? {
        if APIManager.networkEnvironment == .mock {
            guard let data = fetchLocalMockJSONFile(fileName: MockRequestTitles.getPrivatePunchLines) else {
                return nil
            }
            guard let fetchedPrivatePunchLines: [PrivatePunchLine] = decodeJSON(from: data) else {
                return nil
            }
            let filteredPunchLines = fetchedPrivatePunchLines.filter { joinCode == $0.joinCode }.first
            return filteredPunchLines
        } else {
            guard let privatePunchLine: PrivatePunchLine = await handleURLRequest(for: .getPrivatePunchLineWithJoinCode(joinCode: joinCode)) else { return nil }
            return privatePunchLine
        }
    }

    class func post(privatePunchLine: PrivatePunchLinePostRequest) async -> PrivatePunchLine? {
        if APIManager.networkEnvironment == .mock {
            return MockDataManager.createMockPrivatePunchLine(with: privatePunchLine)
        } else {
            guard let privatePunchLine: PrivatePunchLine = await handleURLRequest(for: .postPrivatePunchLine(requestObject: privatePunchLine)) else { return nil }
            return privatePunchLine
        }
    }

    class func deletePrivatePunchLine(with id: String) async -> Bool {
        if APIManager.networkEnvironment == .mock {
            MockDataManager.tempMockPrivatePunchLine = nil
            return true
        } else {
            guard let response: PrivatePunchLineDeleteResponse = await handleURLRequest(for: .deletePrivatePunchLine(punchLineID: id)) else { return false }
            return response.wasSuccessful
        }
    }

    // MARK: Punch-Line Activities

    class func post(setup: SetupPostRequest) async -> Bool {
        if APIManager.networkEnvironment == .mock {
            return true
        } else {
            guard let _: Setup = await handleURLRequest(for: .postSetup(requestObject: setup)) else { return false }
            return true
        }
    }

    class func getSetups(for punchLineID: String) async -> [Setup] {
        if APIManager.networkEnvironment == .mock {
            return MockDataManager.getMockSetupBatch()
        } else {
            guard let setups: [Setup] = await handleURLRequest(for: .getSetups(punchLineID: punchLineID, includeOffensiveContent: AppSessionManager.userInfo?.shouldSeeOffensiveContent ?? false)) else { return [] }
            return setups
        }
    }

    class func report(setup: Setup, for reportReason: SetupReportReason) async -> Bool {
        if APIManager.networkEnvironment == .mock {
            return true
        } else {
            switch reportReason {
            case .offensive:
                guard let response: SetupReportResponse = await handleURLRequest(for: .setupReportOffensive(setupID: setup.id)) else { return false }
                return response.wasSuccessful
            case .unfunny:
                guard let response: SetupReportResponse = await handleURLRequest(for: .setupReportUnfunny(setupID: setup.id)) else { return false }
                return response.wasSuccessful
            }
        }
    }

    class func post(joke: JokePostRequest) async -> Bool {
        if APIManager.networkEnvironment == .mock {
            return true
        } else {
            guard let _: Joke = await handleURLRequest(for: .postJoke(requestObject: joke)) else { return false }
            return true
        }
    }

    class func getJokes(for punchLineID: String) async -> [Joke] {
        if APIManager.networkEnvironment == .mock {
            return MockDataManager.getMockOrPreviewJokeBatch(numberOfJokes: 50)
        } else {
            guard let jokes: [Joke] = await handleURLRequest(for: .getJokes(punchLineID: punchLineID, includeOffensiveContent: AppSessionManager.userInfo?.shouldSeeOffensiveContent ?? false)) else { return [] }
            return jokes
        }
    }

    class func voteOn(joke: Joke, with vote: JokeVote) async -> Bool {
        if APIManager.networkEnvironment == .mock {
            return true
        } else {
            switch vote {
            case .ha:
                guard let response: JokeVoteResponse = await handleURLRequest(for: .jokeVoteHa(jokeID: joke.id)) else { return false }
                return response.wasSuccessful
            case .meh:
                guard let response: JokeVoteResponse = await handleURLRequest(for: .jokeVoteMeh(jokeID: joke.id)) else { return false }
                return response.wasSuccessful
            case .ugh:
                guard let response: JokeVoteResponse = await handleURLRequest(for: .jokeVoteUgh(jokeID: joke.id)) else { return false }
                return response.wasSuccessful
            }
        }
    }

    class func report(joke: Joke, for reportReason: JokeReportReason) async -> Bool {
        if APIManager.networkEnvironment == .mock {
            return true
        } else {
            switch reportReason {
            case .offensive:
                guard let response: JokeReportResponse = await handleURLRequest(for: .jokeReportOffensive(jokeID: joke.id)) else { return false }
                return response.wasSuccessful
            case .tooFunny:
                guard let response: JokeReportResponse = await handleURLRequest(for: .jokeReportTooFunny(jokeID: joke.id)) else { return false }
                return response.wasSuccessful
            }
        }
    }

    // MARK: Joke History
    
    class func getJokeHistoryEntries(for entryGroups: [JokeHistoryEntryGroup]) async -> [String: [JokeHistoryEntry]] {
        if APIManager.networkEnvironment == .mock {

            var entriesResponseDictionary: [String: [JokeHistoryEntry]] = [:]

            for entryGroup in entryGroups {
                entriesResponseDictionary[entryGroup.id] = MockDataManager.getMockJokeHistoryEntries(for: entryGroup)
            }

            return entriesResponseDictionary
        } else {
            guard let jokeHistoryEntries: [String: [JokeHistoryEntry]] = await handleURLRequest(for: .getJokeHistoryEntries(entryGroupIDs: entryGroups.map { $0.id })) else { return [:] }
            return jokeHistoryEntries
        }
    }

    class func getSurvivingJokes(for entryID: String) async -> [SurvivingJoke] {
        if APIManager.networkEnvironment == .mock {
            return MockDataManager.getMockOrPreviewSurvivingJokeBatch(numberOfJokes: 100)
        } else {
            guard let searchResults: [SurvivingJoke] = await handleURLRequest(for: .getSurvivingJokes(entryID: entryID, includeOffensiveContent: AppSessionManager.userInfo?.shouldSeeOffensiveContent ?? false)) else { return [] }
            return searchResults
        }
    }

    // MARK: Joke Lookup

    class func getSearchResults(for searchQuery: String) async -> [SurvivingJoke] {
        if APIManager.networkEnvironment == .mock {
            return MockDataManager.getMockSearchResults(for: searchQuery)
        } else {
            guard let searchResults: [SurvivingJoke] = await handleURLRequest(for: .jokeLookupSearchQuery(searchQuery: searchQuery, includeOffensiveContent: AppSessionManager.userInfo?.shouldSeeOffensiveContent ?? false)) else { return [] }
            return searchResults
        }
    }

    // MARK: Mock Helper Methods

    class func fetchLocalMockJSONFile(fileName: String) -> Data? {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        let fileURL = URL(fileURLWithPath: filePath)
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return data
    }

    // MARK: Generic Networking Methods

    class func handleURLRequest<DecodableObject: Codable>(for requestType: APIRequestType) async -> DecodableObject? {
        guard let url = URL(string: requestType.path) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = requestType.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requestType.httpMethod == HTTPMethods.post {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"

            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)

            switch requestType {
            case .postPrivatePunchLine(let requestObject):
                guard let body = try? jsonEncoder.encode(requestObject) else { return nil }
                request.httpBody = body
            case .postSetup(let requestObject):
                guard let body = try? jsonEncoder.encode(requestObject) else { return nil }
                request.httpBody = body
            case .postJoke(let requestObject):
                guard let body = try? jsonEncoder.encode(requestObject) else { return nil }
                request.httpBody = body
            default:
                break
            }
        }

        guard let (data, _) = try? await URLSession.shared.data(for: request) else { return nil }
        guard let responseObject: DecodableObject = decodeJSON(from: data) else { return nil }

        return responseObject

    }

    class func decodeJSON<DecodableObject: Codable>(from data: Data) -> DecodableObject? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        do {
            let decodedObject = try jsonDecoder.decode(DecodableObject.self, from: data)
            return decodedObject
        } catch {
            print("DECODE ERROR: \(error)")
            return nil
        }
    }

}

enum NetworkEnvironment {
    case mock, test, dev, prod
}
