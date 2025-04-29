//
//  APIManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/16/25.
//

import Foundation

final class APIManager {

    // MARK: Punch-Lines

    class func getPublicPunchLines() async -> [PublicPunchLine] {
        if AppSessionManager.shouldMockNetworkCalls {
            guard let data = fetchLocalMockJSONFile(fileName: MockRequestTitles.getPublicPunchLines) else {
                return []
            }
            guard let fetchedPublicPunchLines: [PublicPunchLine] = decodeJSON(from: data) else {
                return []
            }
            return fetchedPublicPunchLines
        } else {
            // Real Network Call
            return []
        }
    }

    class func getPrivatePunchLines(with ids: [String]) async -> [PrivatePunchLine] {
        if AppSessionManager.shouldMockNetworkCalls {
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
            // Real Network Call
            return []
        }
    }

    class func getPrivatePunchLine(with joinCode: String) async -> [PrivatePunchLine] {
        if AppSessionManager.shouldMockNetworkCalls {
            guard let data = fetchLocalMockJSONFile(fileName: MockRequestTitles.getPrivatePunchLines) else {
                return []
            }
            guard let fetchedPrivatePunchLines: [PrivatePunchLine] = decodeJSON(from: data) else {
                return []
            }
            let filteredPunchLines = fetchedPrivatePunchLines.filter { joinCode == $0.joinCode }
            return filteredPunchLines
        } else {
            // Real Network Call
            return []
        }
    }

    class func post(privatePunchLine: PrivatePunchLinePostRequest) async -> PrivatePunchLine? {
        if AppSessionManager.shouldMockNetworkCalls {
            return MockDataManager.createMockPrivatePunchLine(with: privatePunchLine)
        } else {
            // Real Network Call
            return nil
        }
    }

    class func deletePrivatePunchLine(with id: String) async {
        if AppSessionManager.shouldMockNetworkCalls {
            MockDataManager.tempMockPrivatePunchLine = nil
        } else {
            // Real Network Call
        }
    }

    // MARK: Punch-Line Activities

    class func post(setup: SetupPostRequest) async {
        if AppSessionManager.shouldMockNetworkCalls {
            // Mock Network Call
        } else {
            // Punch-Line Pro Check For UserName
            // Real Network Call
        }
    }

    class func getSetups() async -> [Setup] {
        if AppSessionManager.shouldMockNetworkCalls {
            return MockDataManager.getMockSetupBatch()
        } else {
            // Should Show Offensive Check
            // Punch-Line Pro Check For Own Setups
            // Real Network Call
            return []
        }
    }

    class func report(setup: Setup, for reportReason: SetupReportReason) async {
        if AppSessionManager.shouldMockNetworkCalls {
            // Mock Network Call
        } else {
            // Real Network Call
        }
    }

    class func post(joke: JokePostRequest) async {
        if AppSessionManager.shouldMockNetworkCalls {
            // Mock Network Call
        } else {
            // Punch-Line Pro Check For UserName
            // Real Network Call
        }
    }

    class func getJokes() async -> [Joke] {
        if AppSessionManager.shouldMockNetworkCalls {
            return MockDataManager.getMockOrPreviewJokeBatch(numberOfJokes: 50)
        } else {
            // Should Show Offensive Check
            // Real Network Call
            return []
        }
    }

    class func voteOn(joke: Joke, with vote: JokeVote) async {
        if AppSessionManager.shouldMockNetworkCalls {
            // Mock Network Call
        } else {
            // Real Network Call
        }
    }

    class func report(joke: Joke, for reportReason: JokeReportReason) async {
        if AppSessionManager.shouldMockNetworkCalls {
            // Mock Network Call
        } else {
            // Real Network Call
        }
    }

    // MARK: Joke History

    class func getJokeHistoryEntryGroups(for punchLineID: String) async -> [JokeHistoryEntryGroup] {
        if AppSessionManager.shouldMockNetworkCalls {
            guard let data = fetchLocalMockJSONFile(fileName: MockRequestTitles.getEntryGroups) else {
                return []
            }
            guard var fetchedEntryGroups: [JokeHistoryEntryGroup] = decodeJSON(from: data) else {
                return []
            }
            fetchedEntryGroups.reverse()
            return fetchedEntryGroups
        } else {
            // Real Network Call
            return []
        }
    }

    class func getJokeHistoryEntries(for entryGroup: JokeHistoryEntryGroup) async -> [JokeHistoryEntry] {
        if AppSessionManager.shouldMockNetworkCalls {
            return MockDataManager.getMockJokeHistoryEntries(for: entryGroup)
        } else {
            // Real Network Call
            return []
        }
    }

    // MARK: Joke Lookup

    class func getSearchResults(for searchQuery: String) async -> [HistoryJoke] {
        if AppSessionManager.shouldMockNetworkCalls {
            return MockDataManager.getMockSearchResults(for: searchQuery)
        } else {
            // Real Network Call
            return []
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

    class func decodeJSON<DecodableObject: Codable>(from data: Data) -> DecodableObject? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        do {
            let fetchedSwiftObject = try jsonDecoder.decode(DecodableObject.self, from: data)
            return fetchedSwiftObject
        } catch {
            print("DECODE ERROR: \(error)")
            return nil
        }
    }

}
