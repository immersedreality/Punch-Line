//
//  LocalDataManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/16/25.
//

import Foundation

final class LocalDataManager: ObservableObject {

    static var shared = LocalDataManager()

    @Published private(set) var fetchedPublicPunchLines: [PunchLine] = []

    func set(publicPunchLines: [PunchLine]) {
        DispatchQueue.main.async {
            self.fetchedPublicPunchLines = publicPunchLines
        }
    }

}
