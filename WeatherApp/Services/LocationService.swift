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
    var locationTracker: AnyPublisher<CLLocation, Never> { get }
}

final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationTrackerSubject = PassthroughSubject<CLLocation, Never>()
    
    var locationTracker: AnyPublisher<CLLocation, Never> {
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
        print(newLocation.coordinate)
        locationTrackerSubject.send(newLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("LocationService: didFailWithError")
    }
}
