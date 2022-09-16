//
//  Profile+TableViewDataSource.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.jokeHistoryCell) as? ProfileJokeHistoryTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: ProfileTitles.yourSurvivingJokes)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.jokeHistoryCell) as? ProfileJokeHistoryTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: ProfileTitles.favoriteJokes)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.toggleSettingCell) as? ProfileToggleSettingTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: ProfileTitles.showOffensiveContent, switchType: .offensiveContent)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.proTipCell) else {
                return UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }

    }

}
