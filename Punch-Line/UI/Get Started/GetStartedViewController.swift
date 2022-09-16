//
//  GetStartedViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        configureNavigationController()
        configureLogoImageView()
    }
    
    private func configureNavigationController() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func configureLogoImageView() {
        logoImageView.tintAdjustmentMode = .normal
    }

    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        Task {
            if await CloudKitManager.accountIsAvailable() {
                performSegue(withIdentifier: SegueIdentifiers.showUsernameViewController, sender: nil)
            } else {
                presentOkayAlertWith(title: AlertConstants.cantConnectToiCloudTitle, message: AlertConstants.cantConnectToiCloudMessage)
            }
        }
    }

}
