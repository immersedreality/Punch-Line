//
//  JokeList+TableViewDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension JokeListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard completedPunchLine != nil else { return nil }
        return TableViewSectionTitles.whatMadeTheCut
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

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(
            style: .normal,
            title: TableViewActionTitles.favorite) { (_, _, _) in }
        favoriteAction.backgroundColor = .punchlinePink
        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SurvivingJokeTableViewCell else { return }
        selectedSurvivingJoke = cell.survivingJoke
        performSegue(withIdentifier: SegueIdentifiers.showJokeDetailViewController, sender: self)
    }

}
