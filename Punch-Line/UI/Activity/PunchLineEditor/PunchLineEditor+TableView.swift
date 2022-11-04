//
//  PunchLineEditor+TableView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 11/4/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import UIKit

extension PunchLineEditorViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.matchedPunchLineUserIdentities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.userCell, for: indexPath)

        if let nameComponents = viewModel.matchedPunchLineUserIdentities[indexPath.row].nameComponents {
            cell.largeContentTitle = (nameComponents.givenName ?? "") + " " + (nameComponents.familyName ?? "")
        } else if let email = viewModel.matchedPunchLineUserIdentities[indexPath.row].lookupInfo?.emailAddress {
            cell.largeContentTitle = email
        }

        return cell
    }

}

extension PunchLineEditorViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.matchedPunchLineUserIdentities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
