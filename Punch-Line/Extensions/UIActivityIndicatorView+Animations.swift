//
//  UIActivityIndicatorView+Animations.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/10/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    func fadeInAndBeginAnimating() {
        UIView.animate(
            withDuration: 0.3,
            animations: { self.alpha = 1.0 },
            completion: { _ in self.startAnimating() }
        )
    }

    func fadeOutAndStopAnimating() {
        UIView.animate(
            withDuration: 0.3,
            animations: { self.alpha = 0.0 },
            completion: { _ in self.stopAnimating() }
        )
    }

}
