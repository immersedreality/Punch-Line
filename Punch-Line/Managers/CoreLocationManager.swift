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
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }

    class func startUpdatingUsersLocation(for delegate: CLLocationManagerDelegate) {
        guard CLLocationManager.locationServicesEnabled() else { return }
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
    
}

struct PublicPunchLineLocationMap {
    var country: String?
    var administrativeArea: String?
    var locality: String?
}
