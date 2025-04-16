//
//  APIManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/16/25.
//

import Foundation

final class APIManager {

    private class func fetchLocalMockJSONFile(fileName: String) -> Data? {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        let fileURL = URL(fileURLWithPath: filePath)
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return data
    }

    private class func decodeLocalMockJSONFile<DecodableObject: Codable>(from data: Data) -> DecodableObject? {
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

    class func getPublicPunchLines() async {
        if AppSessionManager.shouldMockNetworkCalls {
            guard let data = fetchLocalMockJSONFile(fileName: "GET-PunchLines") else {
                return
            }
            guard let fetchedPublicPunchLines: [PunchLine] = decodeLocalMockJSONFile(from: data) else {
                return
            }
            LocalDataManager.shared.set(publicPunchLines: fetchedPublicPunchLines)
        } else {
            // Real Network Call
        }
    }

}
