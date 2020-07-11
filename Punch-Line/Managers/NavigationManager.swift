//
//  NavigationManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

final class NavigationManager {

    class func setRootViewControllerToGetStarted() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let storyboard = UIStoryboard(name: StoryboardNames.getStarted, bundle: nil)
        if let getStartedViewController = storyboard.instantiateInitialViewController() {
            appDelegate.window?.rootViewController = getStartedViewController
        }
    }

}
