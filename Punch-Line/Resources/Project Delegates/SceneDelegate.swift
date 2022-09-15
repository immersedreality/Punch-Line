//
//  SceneDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 9/22/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        guard AppSession.user != nil else {
            NavigationManager.setRootViewControllerTo(storyboardName: StoryboardNames.getStarted)
            return
        }

        Task {
            if await CloudKitManager.accountIsAvailable() {
                NavigationManager.setRootViewControllerTo(storyboardName: StoryboardNames.main)
            } else {
                NavigationManager.setRootViewControllerTo(storyboardName: StoryboardNames.getStarted)
            }
        }
        
    }

}


