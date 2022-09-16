//
//  UIViewController+Alerts.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 9/14/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentOkayAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }

    func presentConfirmOrCancelAlertWith(title: String, message: String, confirmIsDestructive: Bool, confirmAction: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let confirmAction = UIAlertAction(title: "Confirm", style: confirmIsDestructive ? .destructive : .default, handler: confirmAction)
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
    
}

