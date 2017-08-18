//
//  LocationManager.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordiantes {
    var latitude: String
    var longitude: String
}

class LocationClient: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationClient()
    
    private let locationManager = CLLocationManager()
    
    var currentLocation: Coordiantes?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = (location?.coordinate.latitude)!
        let longitude = (location?.coordinate.longitude)!
        currentLocation = Coordiantes(latitude: "\(latitude)", longitude: "\(longitude)")
    }
}

