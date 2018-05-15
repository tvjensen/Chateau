//
//  Location.swift
//  Room
//
//  Created by Thomas Jensen on 5/15/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import Foundation
import MapKit
//import UIKit
//import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    public static var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    public static func get() -> CLLocationCoordinate2D? {
        return location
    }


    public static func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let curLocation = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: curLocation.coordinate.latitude,
                                            longitude: curLocation.coordinate.longitude)
        location = center;
        print("LOCATION:")
        print(curLocation.coordinate.latitude)
        print(curLocation.coordinate.longitude)

    }

}
