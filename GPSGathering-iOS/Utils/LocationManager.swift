//
//  LocationManager.swift
//  GPSGathering-iOS
//
//  Created by Yurim Jayde Jeong on 2024/03/05.
//

import CoreLocation
import UIKit

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkPermission() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            /// To make work this request properly, `Privacy - Location When In Use Usage Description`in Info.plist is nessasary.
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            /// Switch screen to the app settings in System Settings
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            break
        case .authorizedAlways, .authorizedWhenInUse:
            /// start update the device location
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

