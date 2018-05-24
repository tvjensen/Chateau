//
//  LocationManager.swift
//  Room
//
//  Created by Conner Smith on 5/16/18.
//  Copyright © 2018 csmith. All rights reserved.
//

import Foundation
import MapKit

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    private var location: CLLocationCoordinate2D?
    let LOCATION_UPDATE_NAME = NSNotification.Name("locUpdate")
    
    private override init() {}
    
    public func startTracking() {
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
    }
    
    public func getLocation() -> CLLocationCoordinate2D? {
        return location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        location = latest.coordinate
        NotificationCenter.default.post(name: LOCATION_UPDATE_NAME, object: location)
    }
    
    
    
}
