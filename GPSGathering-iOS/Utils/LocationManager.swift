//
//  LocationManager.swift
//  GPSGathering-iOS
//
//  Created by Yurim Jayde Jeong on 2024/03/05.
//

import CoreLocation
import CoreData
import UIKit

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    var locations: [NSManagedObject] = [] // to manage CoreData objects
    var container: NSPersistentContainer? = nil
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    private func hasLocationPermission() -> Bool {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            /// To make work this request properly, `Privacy - Location When In Use Usage Description`in Info.plist is nessasary.
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            /// Switch screen to the app settings in System Settings
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .authorizedAlways, .authorizedWhenInUse:
            /// start update the device location
            return true
        @unknown default:
            break
        }
        return false
    }
    
    func startTracking() {
        if hasLocationPermission() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if !hasLocationPermission() { stopTracking() }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            save(data: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func save(data: CLLocation) {
        guard let container = self.container else { return }
        
        let context = container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserLocation", in: context)!
        
        let userLocation = NSManagedObject(entity: entity, insertInto: context)
        
        userLocation.setValue(data.coordinate.latitude, forKey: "latitude")
        userLocation.setValue(data.coordinate.longitude, forKey: "longitude")
        userLocation.setValue(data.timestamp.toString(), forKey: "time")
        
        do {
            try context.save()
            locations.append(userLocation)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}

