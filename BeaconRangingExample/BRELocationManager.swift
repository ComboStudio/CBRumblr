//
//  BRELocationManager.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import CoreLocation

class BRELocationManager: NSObject {

    static var shared = BRELocationManager()
    
    fileprivate var beaconsArray:[BREBeacon]?
    lazy var locationManager:CLLocationManager = {
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        return locationManager
        
    }()
    
    func monitorBeacons(beacons:[BREBeacon]) {
        
        beaconsArray = beacons
        
        // TOOD: Check if permission has already been granted. Don't run this if it has.
        
        locationManager.requestAlwaysAuthorization()

        beaconsArray?.forEach { (beacon: BREBeacon) in
            
            locationManager.startMonitoring(for: beacon.region)
            
            print("Began ranging for beacon:")
            print(beacon.region)
            
        }
        
    }
    
    func getBeaconForRegion(region:CLRegion) -> BREBeacon? {
        
        guard let beaconRegion = region as? CLBeaconRegion else { print("Region isn't a beacon region."); return nil }
        let _beacon = beaconsArray?.filter { $0.uuid.uuidString == beaconRegion.proximityUUID.uuidString }
        guard let beacon = _beacon?.first else { return nil }
        return beacon
        
    }

}

extension BRELocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        
        print("Failed!")
        print(error)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        beacons.forEach { (beacon:CLBeacon) in
            
            let signalStrength = beacon.rssi
            guard let beaconObj:BREBeacon = {
                
                let _idx = self.beaconsArray?.index { beacon.proximityUUID.uuidString == $0.uuid.uuidString }
                guard let idx = _idx else { return nil }
                return self.beaconsArray![idx]
                
                }() else { return }
            
            let distance = abs(signalStrength) / abs(beaconObj.strength.rawValue)
            
            print("\(beaconObj.title) is approximately \(distance) meters from you right now.")
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        guard let beacon = getBeaconForRegion(region: region) else { return }
        
        // It's armed. Let's play!
        
        BREEntranceController.shared.makeEntrance()
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        guard let beacon = getBeaconForRegion(region: region) else { return }
        
        BREPushNotificationController.createPushNotification(message: "Exited region for: " + beacon.title)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
 
        // From what I understand, didDetermineState is a bit of a pinging mechanism.
        
        // For example, if you entered a region, closed the application, then re-opened it, you wouldn't expect to "enter" the region again - because you didn't enter, you just stayed in the same place. didDetermineState will trigger during every "transition" period (i.e. left/re-entered a zone).
        
        // It's also worth mentioning that didDetermineState will be called whilst the app isn't even in memory if the region's notifyEntryOnDisplay is enabled. By default, this is false - but for this demonstration, I've enabled it for every monitored region.
        
        // Finally, didDetermineState can be "forced" by using the locationManager.requestStateFor() method. That means you can request an update and run whatever logic's in here at (roughly) any given time (it's async), which is pretty gnarly.
        
        guard let beacon = getBeaconForRegion(region: region) else { print("Couldn't get beacon."); return }
        
        // Check if the user's INSIDE the region, not outside...
        
        guard state == CLRegionState.inside else { print("Not inside."); return }
        
        // Alright. Time to make our entrance.
        
        BREEntranceController.shared.makeEntrance()
        
    }
    
}
