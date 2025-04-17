//
//  APIManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/16/25.
//

import Foundation

final class APIManager {

    // MARK: Punch-Lines

    class func getPublicPunchLines() async {
        if AppSessionManager.shouldMockNetworkCalls {
            guard let data = fetchLocalMockJSONFile(fileName: "GET-PunchLines") else {
                return
            }
            guard let fetchedPublicPunchLines: [PunchLine] = decodeJSON(from: data) else {
                return
            }
            LocalDataManager.shared.set(publicPunchLines: fetchedPublicPunchLines)
        } else {
            // Real Network Call
        }
    }

    // MARK: Punch-Line Activities

    class func post(setup: SetupPostRequest) async {
        if AppSessionManager.shouldMockNetworkCalls {
            // Mock Network Call
        } else {
            // Real Network Call
        }
    }

    class func getSetups() async -> [Setup] {
        if AppSessionManager.shouldMockNetworkCalls {
            return MockDataManager.getMockSetupBatch()
        } else {
            // Should Show Offensive Check
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
            guard let data = fetchLocalMockJSONFile(fileName: "GET-EntryGroups") else {
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

    class func getSearchResults(for searchQuery: String) async -> [Joke] {
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
