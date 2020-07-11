//
//  PunchLineList+TableViewDatasource.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension PunchLineListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        if indexPath.section == 1 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.newPunchLineCell) as? NewPunchLineTableViewCell ?? UITableViewCell()
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.punchLineCell) as? PunchLineTableViewCell ?? UITableViewCell()
        }

        return cell
    }

}
