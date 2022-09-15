//
//  JokeLookupViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class JokeLookupViewController: UIViewController {

    @IBOutlet weak var selectPunchLineButton: UIButton!
    @IBOutlet weak var selectTimescaleButton: UIButton!
    @IBOutlet weak var selectSortButton: UIButton!
    @IBOutlet weak var jokeSearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
//        configureNavigationBar()
    }

    private func configureNavigationBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Icon-NavigationTitle"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .punchlinePink
        self.navigationItem.titleView = imageView
    }

    @IBAction func selectPunchLineButtonTapped(_ sender: Any) {
    }

    @IBAction func selectTimescaleButtonTapped(_ sender: Any) {
    }

    @IBAction func selectSortButtonTapped(_ sender: Any) {
    }

    @IBAction func profileButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers.presentProfileViewController, sender: self)
    }
    
}
