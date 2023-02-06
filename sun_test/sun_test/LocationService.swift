//
//  LocationService.swift
//  sun_test
//
//  Created by Ellen Moore on 2/6/23.
//

import Combine
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject{
    
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
    
    private override init(){
        super.init()
    }
    
    static let shared = LocationService()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    //requests the location of user
    func requestLocationUpdates(){
        switch locationManager.authorizationStatus{
        case.notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case.authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            deniedLocationAccessPublisher.send(())
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //just want the last location
        guard let location = locations.last else {return}
        coordinatesPublisher.send(location.coordinate)
    }
    
    // error delegate, send a failure
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
    
    
}
