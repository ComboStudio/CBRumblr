//
//  BRELocationManager.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import CoreLocation

protocol BRELocationManagerDelegate {
    
    func beaconFound(beacon:BREBeacon)
    func beaconNotFound()
    
}

class BRELocationManager: NSObject {
    
    static var shared = BRELocationManager()
    
    var delegate:BRELocationManagerDelegate?
    
    fileprivate var regionsArray:[BREBeaconRegion]?
    fileprivate var beaconsInRange:[BREBeacon] = []
    
    lazy var locationManager:CLLocationManager = {
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        return locationManager
        
    }()
    
    func beginMonitoring() {
        
        let url = Bundle.main.url(forResource: "beacons", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        let _regionsArray = dictionary["regions"] as! [[String:Any]]
        let regionsArray = _regionsArray.flatMap { return BREBeaconRegion(dictionary: $0) }
        
        self.regionsArray = regionsArray
        
    }
    
    fileprivate func monitorRegions() {
        
        // TOOD: Check if permission has already been granted. Don't run this if it has.
        
        locationManager.requestAlwaysAuthorization()
        
        regionsArray?.forEach({ (region:BREBeaconRegion) in
        
        locationManager.startRangingBeacons(in: region.region)
            
        })
        
    }
    
    fileprivate func stopMonitoring() {
        
        locationManager.monitoredRegions.forEach { (region:CLRegion) in
            
            locationManager.stopMonitoring(for: region)
            
        }
        
    }
    
}

extension BRELocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        
        print("Failed!")
        print(error)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        guard let regionsArray = regionsArray else { return }
        
        // First, we range. 
        
        // When you range multiple beacons at a time, this function is called once a second for _every beacon_ you range. That means if you're ranging four beacons at once, this will call four times. If you're in range of one of them, ONE of those callbacks will have a discovered beacon. The other three will return empty arrays.
        
        // The clue for what this does is in the name - it helps us understand how close each of the beacon is from the device, and comes back to us periodically to let us know which beacons it's found in the surrounding area in the form of this delegate method. Neat, right?
        
        // What we can do with this information is understand how close they are, and if the beacon's close enough, we can startMonitoring for it. We'll go into startMonitoring later - let's just get our heads around the clusterfuck that is ranging, first.
        
        // Find region first
        
        let idx = regionsArray.index { region.proximityUUID.uuidString == $0.uuid.uuidString }
        let region = regionsArray[idx!]
        
        guard let beaconsArray = region.beacons else { return }
        
        beacons.forEach { (beacon:CLBeacon) in
            
            let signalStrength = beacon.rssi
            
            let beaconObj:BREBeacon = {
                
                // We can comfortably force-unwrap this because, unless we pull beacons through other methods other than the .json supplied, we won't have the information for any other beacon information that would be pulled up whilst scanning.
                
                let idx = beaconsArray.index { beacon.minor.intValue == $0.minor }
                return beaconsArray[idx!]
                
            }()

            // For the future, we'll need to know if there's a beacon in range.
            
            let inRangeIdx = beaconsInRange.index { $0.minor == beaconObj.minor }
            
            // Right, we've found a beacon. Is it within the programmed range we've specified for it to trigger?
            
            if beaconObj.isInRange(rssi: signalStrength) {
                
                // ...it bloody is! But wait - is it already in the array already? Have we found this beacon already?
                
                if inRangeIdx == nil {
                    
                    // It isn't. Let's add it to the array and start monitoring it!
                    
                    print("New beacon began being monitored: " + beaconObj.title)
                    
                    beaconsInRange.append(beaconObj)
                    
                   
                }
                
                else {
                    
                    // Ah, looks like it is.

                    // Keep calm, carry on.
                    
                }
                
            }
            
            else {
                
                // Beacon isn't in range. We can ignore this - unless, of course, it was already in the beacons array?
                
                if inRangeIdx != nil {
                    
                    print("Beacon's no longer being monitored: " + beaconObj.title)
                    
                    // If it was in the beacon array, we can assume that we've just left the area.
                    
                    let regionIdx = locationManager.monitoredRegions.index(where: { (region:CLRegion) -> Bool in
                        
                        guard
                            let region = region as? CLBeaconRegion,
                            let regionMinor = region.minor?.intValue
                        else { return false }
                        
                        return regionMinor == beaconObj.minor
                        
                    })
                    
                    beaconsInRange.remove(at: inRangeIdx!)
                    
                    if let idx = regionIdx {
                        
                        locationManager.stopMonitoring(for: locationManager.monitoredRegions[idx])
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        // Right.
        
//        delegate?.beaconFound(beacon: beacon)
//        stopMonitoring()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        // From what I understand, didDetermineState is a bit of a pinging mechanism.
        
        // For example, if you entered a region, closed the application, then re-opened it, you wouldn't expect to "enter" the region again - because you didn't enter, you just stayed in the same place. didDetermineState will trigger during every "transition" period (i.e. left/re-entered a zone).
        
        // It's also worth mentioning that didDetermineState will be called whilst the app isn't even in memory if the region's notifyEntryOnDisplay is enabled. By default, this is false - but for this demonstration, I've enabled it for every monitored region.
        
        // Finally, didDetermineState can be "forced" by using the locationManager.requestStateFor() method. That means you can request an update and run whatever logic's in here at (roughly) any given time (it's async), which is pretty gnarly.
        
//        guard let beacon = getBeaconForRegion(region: region) else { print("Couldn't get beacon."); return }
//        
//        // Check if the user's INSIDE the region, not outside...
//        
//        guard state == CLRegionState.inside else { print("Not inside."); return }
//        
//        // Alright. Time to make our entrance.
//        
//        delegate?.beaconFound(beacon: beacon)
//        stopMonitoring()
//        
    }
    
}
