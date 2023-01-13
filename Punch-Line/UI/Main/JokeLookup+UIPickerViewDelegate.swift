//
//  JokeLookup+UIPickerViewDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 1/5/23.
//  Copyright © 2023 Bozo Design Labs. All rights reserved.
//

import UIKit

extension JokeLookupViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.currentPunchLineLaunchers.count
    }

}

extension JokeLookupViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.currentPunchLineLaunchers[row].displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedPunchLineLauncherIndex = row
        updateWithSelectedPunchLine()
    }

}
