//
//  JokeLookupViewController.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/8/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class JokeLookupViewController: UIViewController {

    @IBOutlet weak var selectPunchLineTextField: UITextField!
    @IBOutlet weak var selectDateTextField: UITextField!

    let selectPunchLinePickerView = UIPickerView()
    let selectDatePickerView = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelectPunchLinePickerView()
        configureSelectDatePickerView()
        configureTextFields()
    }

    private func configureSelectPunchLinePickerView() {
        selectPunchLinePickerView.delegate = self
        selectPunchLinePickerView.backgroundColor = StyleManager.generateRandomBackgroundColor()
        selectPunchLinePickerView.tintColor = .punchlinePink
    }

    private func configureSelectDatePickerView() {
        selectDatePickerView.preferredDatePickerStyle = .inline
        selectDatePickerView.datePickerMode = .date
        selectDatePickerView.timeZone = TimeZone.current
        selectDatePickerView.date = Date()
        selectDatePickerView.backgroundColor = StyleManager.generateRandomBackgroundColor()
        selectDatePickerView.tintColor = .punchlinePink
    }

    private func configureTextFields() {
        selectPunchLineTextField.delegate = self
        selectPunchLineTextField.inputView = selectPunchLinePickerView

        selectDateTextField.delegate = self
        selectDateTextField.inputView = selectDatePickerView
    }

    @IBAction func profileButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers.presentProfileViewController, sender: self)
    }
    
}
