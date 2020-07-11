//
//  GetStartedViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/9/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

    var userAuthorizationManager: UserAuthorizationManager?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        configureNavigationController()
    }
    
    private func configureNavigationController() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        userAuthorizationManager = UserAuthorizationManager(authorizationMode: .newUser)
        performSegue(withIdentifier: SegueIdentifiers.showUsernameViewController, sender: self)
    }
    
    @IBAction func signIntoAnExistingAccountButtonTapped(_ sender: Any) {
        userAuthorizationManager = UserAuthorizationManager(authorizationMode: .returningUser)
        performSegue(withIdentifier: SegueIdentifiers.showUsernameViewController, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueIdentifiers.showUsernameViewController else { return }
        guard let usernameViewController = segue.destination as? UsernameViewController else { return }
        usernameViewController.userAuthorizationManager = userAuthorizationManager
    }

}
