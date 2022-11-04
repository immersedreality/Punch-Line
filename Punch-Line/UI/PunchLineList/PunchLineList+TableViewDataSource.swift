//
//  PunchLineList+TableViewDataSource.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension PunchLineListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 2

        if viewModel.joinedCustomPunchlineLaunchers.count > 0 {
            numberOfSections += 1
        }

        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.publicPunchLineLaunchers.count
        case 1:
            return viewModel.ownedCustomPunchlineLaunchers.count + 1
        case 2:
            return viewModel.joinedCustomPunchlineLaunchers.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.punchLineCell) as? PunchLineTableViewCell else {
                return UITableViewCell()
            }
            cell.punchLineLauncher = viewModel.publicPunchLineLaunchers[indexPath.row]
            return cell
        case 1:
            if indexPath.row == viewModel.ownedCustomPunchlineLaunchers.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.newPunchLineCell) as? NewPunchLineTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.punchLineCell) as? PunchLineTableViewCell else {
                    return UITableViewCell()
                }
                cell.punchLineLauncher = viewModel.ownedCustomPunchlineLaunchers[indexPath.row]
                return cell
            }
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.punchLineCell) as? PunchLineTableViewCell else {
                return UITableViewCell()
            }
            cell.punchLineLauncher = viewModel.joinedCustomPunchlineLaunchers[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }

    }

}
