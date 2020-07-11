//
//  PunchLineList+TableViewDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

extension PunchLineListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 36))
        headerView.backgroundColor = UIColor.white

        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        titleLabel.textColor = ColorConstants.punchlinePink
        headerView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        switch section {
        case 0:
            titleLabel.text = TableViewSectionTitles.theWorld
        case 1:
            titleLabel.text = TableViewSectionTitles.yourGroups
        default:
            return nil
        }

        return headerView
    }

}
