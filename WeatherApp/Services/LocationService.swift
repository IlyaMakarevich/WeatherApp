//
//  LocationService.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation
import CoreLocation
import Combine

protocol LocationServiceProtocol {
    func requestPermissionAndStartTracking()
    func forceUpdateLocation()
    var locationTracker: AnyPublisher<CLLocation?, Never> { get }
}

final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationTrackerSubject = PassthroughSubject<CLLocation?, Never>()
    
    private var newLocation: CLLocation?
    
    var locationTracker: AnyPublisher<CLLocation?, Never> {
        return locationTrackerSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestPermissionAndStartTracking() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func forceUpdateLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        guard let newLocation else { return }
        locationTrackerSubject.send(newLocation)
        self.newLocation = newLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if newLocation == nil {
            locationTrackerSubject.send(nil)
        }
    }
}
