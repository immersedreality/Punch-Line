//
//  PunchLineList+CLLocationManagerDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CoreLocation

extension PunchLineListViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways || status == .authorizedWhenInUse else { return }
        CoreLocationManager.startUpdatingUsersLocation(for: self)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        CoreLocationManager.reverseGeocode(location: location) { (locationMap) in
            guard locationMap.country != nil && locationMap.administrativeArea != nil && locationMap.locality != nil else { return }
            CoreLocationManager.stopUpdatingUsersLocation()
            PunchLineSyncManager.matchPublicPunchLineNames(to: locationMap, completion: { [weak self] thereAreNewPunchLines in
                DispatchQueue.main.async {
                    if thereAreNewPunchLines {
                        self?.reloadTableViewWithAnimation()
                    }
                }
            })
        }
    }

}
