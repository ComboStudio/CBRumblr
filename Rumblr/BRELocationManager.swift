//
//  BRELocationManager.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

enum BRELocationManagerError:Error {
    
    case bluetoothIsDisabled
    case locationServicesAreDisabled
    case rangingUnavailable
    case unknownError
    
    var description:String {
        
        switch self {
            
        case .bluetoothIsDisabled: return "Bluetooth is currently disabled. Enable it on your device and try again!"
        case .locationServicesAreDisabled: return "Location services are currently disabled for Rumblr. Head over to Settings and enable it in Location Services, then try again."
        case .rangingUnavailable: return "Beacon ranging for this device is unavailable, sorry!"
        case .unknownError: return "An unknown error occured whilst searching for beacons."
            
        }
        
    }
    
}

protocol BRELocationManagerDelegate:class {
    
    func beaconDiscoveredNewBeacon(beacon:BREBeacon)
    func beaconScanningFailed(error:BRELocationManagerError)
    func beaconOutOfRange(beacon:BREBeacon)
    
}

class BRELocationManager: NSObject {
    
    weak var delegate:BRELocationManagerDelegate?
    
    fileprivate var regionsArray:[BREBeaconRegion]?
    fileprivate var beaconsInRange:[BREBeacon] = []
    
    fileprivate lazy var bluetoothController:BREBluetoothController = {
        
        let controller = BREBluetoothController()
        return controller
        
    }()
    
    lazy fileprivate var locationManager:CLLocationManager = {
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        return locationManager
        
    }()
    
    override init() {
        
        guard
            let url = Bundle.main.url(forResource: "beacons", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let _dictionary = try? JSONSerialization.jsonObject(with: data, options: []),
            let dictionary = _dictionary as? [String:Any],
            let regionsArray = dictionary["regions"] as? [[String:Any]] else {
                
                print("Error occured: Beacons.json couldn't be parsed correctly. Make sure it's valid and try again.")
                return
        
        }
        
        self.regionsArray = regionsArray.flatMap { return BREBeaconRegion(dictionary: $0) }
        
    }
    
    func beginMonitoring() {
        
        // Right, before we actually start, we need to check that bluetooth is available and the required permissions have been given to the application. Let's do that before going any further...
        
        bluetoothController.checkIfBluetoothIsEnabled { [weak self] (isEnabled:Bool) in
            
            if isEnabled {
                
                // It is, we're golden. Let's request authorization!
                
                self?.locationManager.requestAlwaysAuthorization()
                return
                
            }
                
            else {
                
                // Bluetooth is disabled! Let's tell the user...
                
                self?.delegate?.beaconScanningFailed(error: BRELocationManagerError.bluetoothIsDisabled)
                return
                
            }
        }
        
    }
    
    func stopMonitoring() {
        
        regionsArray?.forEach({ (region:BREBeaconRegion) in
            
            locationManager.stopRangingBeacons(in: region.region)
            locationManager.stopMonitoring(for: region.region)
            
        })
        
    }
    
    fileprivate func monitorRegions() {
        
        regionsArray?.forEach({ (region:BREBeaconRegion) in
            
            locationManager.startRangingBeacons(in: region.region)
            locationManager.startMonitoring(for: region.region)
            
        })
        
    }
    
    
}

extension BRELocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .notDetermined {
            
            // Not determined, but we can assume the user has been prompted.
            return
            
        }
        
        guard status == .authorizedAlways else {
            
            // The status has been determined (i.e. the user has allowed/not allowed the
            
            delegate?.beaconScanningFailed(error: .locationServicesAreDisabled)
            return
            
        }
        
        monitorRegions()
        
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        
        delegate?.beaconScanningFailed(error: BRELocationManagerError.unknownError)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        guard let regionsArray = regionsArray else { return }
        
        // First, we range.
        
        // When you range multiple beacons at a time, this function is called once a second for _every beacon_ you range. That means if you're ranging four beacon regions at once, this will call four times. If you're in range of one of them, ONE of those callbacks will have a discovered beacon. The other three will return empty arrays.
        
        // The way we've handled this is by dividing our beacons into regions. Each region shares the same UUID, they just have different Minor values to help us identify them. You can head over to beacons.json if you're confused by this - the structure over there should make things fairly clear.
        
        // The clue for what this does is in the name - it helps us understand how close each of the beacon is from the device, and comes back to us periodically to let us know which beacons it's found in the surrounding area in the form of this delegate method. Neat, right?
        
        // We're going to use the ranging system to identify how close we are to the beacons in our list. If we're close enough to one that's set up to trigger (see the shouldTrigger property in the BREBeacon model), and we're ready to make our entrance, it'll tell the user that they're ready to go!
        
        // Find region first
        
        let idx = regionsArray.index { region.proximityUUID.uuidString == $0.uuid.uuidString }
        let region = regionsArray[idx!]
        
        guard let beaconsArray = region.beacons else { return }
        
        beacons.forEach { (beacon:CLBeacon) in
            
            let signalStrength = beacon.rssi
            
            // Check that we actually have a decent RSSI - iBeacons have a weird tendency of just sending an RSSI of 0 whenever the signal isn't strong enough.
            
            guard signalStrength < 0 else { return }
            
            // Identify which beacon has been ranged by the device. Doing this will help us understand whether we should or shouldn't trigger starting the music (again, see the shouldTrigger property).
            
            let beaconObj:BREBeacon = {
                
                let idx = beaconsArray.index { beacon.minor.intValue == $0.minor }
                return beaconsArray[idx!]
                
            }()
            
            // Right, bit of a confusing step here. We're going to measure the strength of the signal offered by the beacon (.rssi), and ignore it until it's strong enough.
            
            let inRangeIdx = beaconsInRange.index { $0.minor == beaconObj.minor }
            
            // Right, so we've found a beacon! Is it within the programmed range we've specified for it to trigger?
            
            if beaconObj.isInRange(rssi: signalStrength) {
                
                // ...it bloody is! But wait - is it already in the array already? Have we found this beacon already?
                
                if inRangeIdx == nil {
                    
                    // It isn't. Let's add it to the array and start monitoring it!
                    
                    beaconsInRange.append(beaconObj)
                    delegate?.beaconDiscoveredNewBeacon(beacon: beaconObj)
                    
                }
                    
                else {
                    
                    // Ah, looks like it was already in the array. This method gets called over and over until it's told to stop ranging, so we can just ignore this. This time, we've stayed within range.
                    
                    // Keep calm, carry on.
                    
                }
                
            }
                
            else {
                
                // Beacon isn't in range. We can ignore this - unless, of course, it was already in the beacons array? If it was, that means we've just moved out of signal, so let's check if it's in range using that handy index we calculated earlier...
                
                if inRangeIdx != nil {
                    
                    // Yup, we've just stepped out of range. Let's remove it and alert the delegate.
                    
                    beaconsInRange.remove(at: inRangeIdx!)
                    delegate?.beaconOutOfRange(beacon: beaconObj)
                    
                }
                
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        // Right, didDetermineState is a bit of a pinging mechanism.
        
        // For example, if you entered a region, closed the application, then re-opened it, you wouldn't expect to "enter" the region again - because you didn't enter, you just stayed in the same place. didDetermineState will trigger during every "transition" period (i.e. left/re-entered a zone).
        
        // It's also worth mentioning that didDetermineState will be called whilst the app isn't even in memory if the region's notifyEntryOnDisplay is enabled. By default, this is false - but for this demonstration, I've enabled it for every monitored region.
        
        // When notifyEntryOnDisplay is enabled for a monitored region, when the device WAKES (not even unlocked!), the device will do a quick pass for any beacons in range. If it finds one, it'll wake the app and fire this method. Using this, we can fire off a push notification when the user's within range of one of our beacons to get them to make their entrance!
        
        // Final note - didDetermineState can be "forced" by using the locationManager.requestStateFor() method. That means you can request an update and run whatever logic's in here at (roughly) any given time (it's async), which is pretty gnarly.
        
        // Check if the user's INSIDE the region, not outside...
        
        guard state == CLRegionState.inside else { print("Not inside."); return }
        
        // Alright, we're in range. Time to get the user to open the app and make their entrance.
        
        BREPushNotificationController.createPushNotification(message: "Ready to make your big entrance?")
        
    }
    
}
