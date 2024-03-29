//
//  PunchLineList+TableViewDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension PunchLineListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return TableViewSectionTitles.thePublic
        case 1:
            return TableViewSectionTitles.yourGroups
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.tintColor = .white
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        headerView.textLabel?.textColor = .punchlinePink
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.section {
        case 0:
            viewModel.selectedPunchLineLauncher = viewModel.publicPunchLineLaunchers[indexPath.row]
            performSegue(withIdentifier: SegueIdentifiers.presentActivityFeedViewController, sender: self)
        case 1:
            if indexPath.row == viewModel.customPunchLineLaunchers.count {
                performSegue(withIdentifier: SegueIdentifiers.presentPunchLineEditorViewController, sender: self)
            } else {
                viewModel.selectedPunchLineLauncher = viewModel.customPunchLineLaunchers[indexPath.row]
                performSegue(withIdentifier: SegueIdentifiers.presentActivityFeedViewController, sender: self)
            }
        default:
            return
        }
        
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 && indexPath.row < viewModel.customPunchLineLaunchers.count else { return nil }
        let leaveGroupAction = UIContextualAction(
            style: .normal,
            title: TableViewActionTitles.leave) { (_, _, _) in }
        leaveGroupAction.backgroundColor = .punchlinePink
        let configuration = UISwipeActionsConfiguration(actions: [leaveGroupAction])
        return configuration
    }

}
