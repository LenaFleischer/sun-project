//
//  LocationFinder.swift
//  sun_test
//
//  Created by Ellen Moore on 2/1/23.
//
// To find the users location

import UIKit
import MapKit
import CoreLocation

class LocationFinder: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this will request the location while the app is in use
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    // finds the latitude and the longitude
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("latitude: \(locValue.latitude), longitude: \(locValue.longitude)")
    }
}
