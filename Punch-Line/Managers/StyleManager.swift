//
//  StyleManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit
import GameplayKit

final class StyleManager {

    class func generateRandomBackgroundColor() -> UIColor {
        let numberGenerator = GKRandomDistribution(lowestValue: 205, highestValue: 255)
        let redValue = CGFloat(numberGenerator.nextInt())/255
        let greenValue = CGFloat(numberGenerator.nextInt())/255
        let blueValue = CGFloat(numberGenerator.nextInt())/255
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }

}
