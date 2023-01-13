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

    var jokeListViewController: JokeListViewController!

    let selectPunchLinePickerView = UIPickerView()
    let selectDatePickerView = UIDatePicker()

    let viewModel = JokeLookupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelectPunchLinePickerView()
        configureSelectDatePickerView()
        configureTextFields()
        configureJokeList()
    }

    private func configureSelectPunchLinePickerView() {
        selectPunchLinePickerView.delegate = self
        selectPunchLinePickerView.dataSource = self
        selectPunchLinePickerView.backgroundColor = StyleManager.generateRandomBackgroundColor()
        selectPunchLinePickerView.tintColor = .punchlinePink
        Task {
            await viewModel.configureCurrentPunchLineLaunchers()
            selectPunchLinePickerView.reloadAllComponents()
        }
    }

    private func configureSelectDatePickerView() {
        selectDatePickerView.preferredDatePickerStyle = .inline
        selectDatePickerView.datePickerMode = .date
        selectDatePickerView.timeZone = TimeZone.current
        selectDatePickerView.date = viewModel.selectedDate
        selectDatePickerView.backgroundColor = StyleManager.generateRandomBackgroundColor()
        selectDatePickerView.tintColor = .punchlinePink

        let selectDateAction = UIAction { [weak self] _ in
            self?.viewModel.selectedDate = self?.selectDatePickerView.date ?? Date()
            self?.updateWithSelectedDate()
        }

        selectDatePickerView.addAction(selectDateAction, for: .valueChanged)
    }

    private func configureTextFields() {
        selectPunchLineTextField.delegate = self
        selectPunchLineTextField.inputView = selectPunchLinePickerView
        selectPunchLineTextField.text = AppSessionManager.currentPublicPunchLineLaunchers.first?.displayName ?? "PunchLine"

        selectDateTextField.delegate = self
        selectDateTextField.inputView = selectDatePickerView
        selectDateTextField.text = viewModel.selectedDate.formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted)
    }

    private func configureJokeList() {
        Task {
            await viewModel.fetchCompletedPunchLineForCurrentLauncherAndDate()
            jokeListViewController.completedPunchLine = viewModel.currentCompletedPunchLine
        }
    }

    func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideTextFieldEditingView))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func hideTextFieldEditingView() {
        view.gestureRecognizers?.removeAll()
        selectPunchLineTextField.resignFirstResponder()
        selectDateTextField.resignFirstResponder()
    }

    func updateWithSelectedPunchLine() {
        selectPunchLineTextField.text = viewModel.currentPunchLineName
        configureJokeList()
    }

    func updateWithSelectedDate() {
        selectDateTextField.text = viewModel.selectedDate.formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted)
        configureJokeList()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers.presentProfileViewController, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.embedJokeListViewControllerInContainerView {
            jokeListViewController = segue.destination as? JokeListViewController
        }
    }

}
