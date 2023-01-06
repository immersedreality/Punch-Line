//
//  CoreLocationManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 7/11/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import Foundation
import CoreLocation

final class CoreLocationManager {

    private static let locationManager = CLLocationManager()
    private static let geocoder = CLGeocoder()

    class func handleLocationServicesAuthorizationStatus(for delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }

    class func startUpdatingUsersLocation(for delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    class func stopUpdatingUsersLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }

    class func reverseGeocode(location: CLLocation, completion: @escaping (PublicPunchLineLocationMap) -> Void) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard error == nil else { completion(PublicPunchLineLocationMap()); return }
            guard let placemark = placemarks?.first else { completion(PublicPunchLineLocationMap()); return }
            let country = placemark.country
            let administrativeArea = placemark.administrativeArea
            let locality = placemark.locality
            let locationMap = PublicPunchLineLocationMap(country: country, administrativeArea: administrativeArea, locality: locality)
            completion(locationMap)
        }
    }

    class func matchUserToPublicPunchlines(using locationMap: PublicPunchLineLocationMap) async {

        AppSessionManager.currentPublicPunchLineLaunchers.removeAll()

        var newPublicPunchLineLaunchers: [PunchLineLauncher] = []

        if let country = locationMap.country {
            if let matchedLauncher = await CloudKitManager.getPublicPunchLineLauncher(for: .country, locationName: country) {
                newPublicPunchLineLaunchers.append(matchedLauncher)
            } else {
                if let newPublicLauncher = await CloudKitManager.createNewPublicPunchLineLauncher(for: .country, locationName: country) {
                    newPublicPunchLineLaunchers.append(newPublicLauncher)
                }
            }
        }

        if let administrativeArea = locationMap.administrativeArea {
            if let matchedLauncher = await CloudKitManager.getPublicPunchLineLauncher(for: .stateOrProvince, locationName: administrativeArea) {
                newPublicPunchLineLaunchers.append(matchedLauncher)
            } else {
                if let newPublicLauncher = await CloudKitManager.createNewPublicPunchLineLauncher(for: .stateOrProvince, locationName: administrativeArea) {
                    newPublicPunchLineLaunchers.append(newPublicLauncher)
                }
            }
        }

        if let locality = locationMap.locality {
            if let matchedLauncher = await CloudKitManager.getPublicPunchLineLauncher(for: .city, locationName: locality) {
                newPublicPunchLineLaunchers.append(matchedLauncher)
            } else {
                if let newPublicLauncher = await CloudKitManager.createNewPublicPunchLineLauncher(for: .city, locationName: locality) {
                    newPublicPunchLineLaunchers.append(newPublicLauncher)
                }
            }
        }

        AppSessionManager.currentPublicPunchLineLaunchers.append(contentsOf: newPublicPunchLineLaunchers)

    }
    
}

struct PublicPunchLineLocationMap {
    var country: String?
    var administrativeArea: String?
    var locality: String?
}
