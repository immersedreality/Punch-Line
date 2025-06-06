//
//  GlobalNotificationManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import Foundation

class GlobalNotificationManager: ObservableObject {

    static let shared = GlobalNotificationManager()

    @Published var shouldLaunchTrainingMode = false
    @Published var shouldRefreshPunchLines = false
    @Published var favoritesHaveBeenUpdated = false
    @Published var appModesHaveChanged = false

    func refreshView() {
        objectWillChange.send()
    }
    
}
