//
//  JokeList+TableViewDataSource.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/12/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension JokeListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedPunchLine?.topTenSetUps.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.survivingJokeCell) as? SurvivingJokeTableViewCell else {
            return UITableViewCell()
        }
        guard let completedPunchLine else { return UITableViewCell() }

        cell.survivingJoke = SurvivingJoke(
            setup: completedPunchLine.topTenSetUps[indexPath.row],
            setupAuthor: completedPunchLine.topTenSetUpAuthors[indexPath.row],
            punchline: completedPunchLine.topTenPunchlines[indexPath.row],
            punchlineAuthor: completedPunchLine.topTenPunchlineAuthors[indexPath.row],
            dateCreated: completedPunchLine.dateCompleted
        )

        return cell
    }

}
