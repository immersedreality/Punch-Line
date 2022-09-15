//
//  NavigationManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

final class NavigationManager {

    class func setRootViewControllerTo(storyboardName: String) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let getStartedViewController = storyboard.instantiateInitialViewController() {
            sceneDelegate.window?.rootViewController = getStartedViewController
        }
    }
    
}
