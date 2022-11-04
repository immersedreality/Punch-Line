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

            Task {
                await viewModel.generatePublicPunchLineToLaunch()

                guard let punchlineIndex = AppSessionManager.userInfo?.todaysPunchlines.firstIndex(of: viewModel.punchlineToLaunch?.cloudKitID.recordName ?? "") else {
                    performSegue(withIdentifier: SegueIdentifiers.presentActivityFeedViewController, sender: self)
                    return
                }

                guard let todaysTaskCount = AppSessionManager.userInfo?.todaysTaskCounts[punchlineIndex] else {
                    performSegue(withIdentifier: SegueIdentifiers.presentActivityFeedViewController, sender: self)
                    return
                }

                viewModel.setUpToLaunchWith = nil
                viewModel.jokeToLaunchWith = nil
                
                switch todaysTaskCount {
                case 1...2:
                    break
                case 3, 5, 8, 12, 17, 23, 30, 38, 47, 57:
                    await viewModel.getARandomSetup()
                default:
                    await viewModel.getARandomJoke()
                }

                performSegue(withIdentifier: SegueIdentifiers.presentActivityFeedViewController, sender: self)
            }
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
    
}
