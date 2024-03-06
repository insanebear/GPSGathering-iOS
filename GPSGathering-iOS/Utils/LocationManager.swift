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
    
    var isTracking: Bool = false {
        didSet {
            UserDefaults.standard.set(isTracking, forKey: "isTracking")
            updateUI()
        }
    }
    
    private let locationManager = CLLocationManager()
    var locations: [NSManagedObject] = [] // to manage CoreData objects
    var container: NSPersistentContainer? = nil
    var uiDelegate: ViewControllerDelegate? = nil
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startTracking() {
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            /// To make work this request properly, `Privacy - Location When In Use Usage Description`in Info.plist is nessasary.
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            /// Switch screen to the app settings in System Settings
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .authorizedAlways, .authorizedWhenInUse:
            /// start update the device location
            locationManager.startUpdatingLocation()
            isTracking.toggle()
        @unknown default:
            break
        }
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        isTracking.toggle()
    }
    
    func updateUI() {
        guard let uiDelegate = uiDelegate else { return }
        uiDelegate.updateStatus(isTracking: isTracking)
    }
    
    private func checkIfTrackingNeedAborting() {
        let isTracking: Bool = UserDefaults.standard.object(forKey: "isTraking") as? Bool ?? false
        let stopConditions: [CLAuthorizationStatus] = [.denied, .restricted]
        let authStatus = locationManager.authorizationStatus
        
        if isTracking && stopConditions.contains(authStatus) {
            print("Under not trackable status. Stopping the tracking.")
            stopTracking()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // The system calls this the app creates the CLLocationManager instance.
        checkIfTrackingNeedAborting()
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

