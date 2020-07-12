//
//  PunchLineSync+CLLocationManagerDelegate.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CoreLocation

extension PunchLineSyncManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways || status == .authorizedWhenInUse else { return }
        CoreLocationManager.startUpdatingUsersLocation(for: self)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        CoreLocationManager.reverseGeocode(location: location) { (locationMap) in
            PunchLineSyncManager.matchPublicPunchLineNames(to: locationMap)
        }
    }

}
