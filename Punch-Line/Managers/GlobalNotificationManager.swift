//
//  GlobalNotificationManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import Foundation

class GlobalNotificationManager: ObservableObject {

    static let shared = GlobalNotificationManager()

    @Published var shouldRefreshPunchLines = false
    @Published var favoritesHaveBeenUpdated = false

    func refreshView() {
        objectWillChange.send()
    }
    
}
