//
//  PunchLineApp.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/18/25.
//

import SwiftUI
//import AppTrackingTransparency

@main
struct PunchLineApp: App {

//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let viewModel = PunchLineAppViewModel()

    init() {
        viewModel.validateUserInfo()
//        AppSessionManager.setAdTimer()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
//                .onAppear {
//                    requestIDFA()
//                }
        }
    }

//    private func requestIDFA() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//            })
//        }
//    }

}
