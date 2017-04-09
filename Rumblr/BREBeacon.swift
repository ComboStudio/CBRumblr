//
//  BREBeacon.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import CoreLocation

enum BREBeaconStrength:Int {
    
    case whisper = -89
    case mutter = -85
    case talk = -82
    case shout = -75
    case scream = -63
    
}

class BREBeacon: NSObject {
    
    var title:String
    var major:Int
    var minor:Int
    var strength:BREBeaconStrength
    var shouldTrigger:Bool
    
    init?(dictionary:[String:Any]) {
        
        guard
            let title = dictionary["beacon_name"] as? String,
            let major = dictionary["major"] as? Int,
            let minor = dictionary["minor"] as? Int,
            let strengthInt = dictionary["strength"] as? Int,
            let strength = BREBeaconStrength(rawValue: strengthInt),
            let shouldTrigger = dictionary["should_trigger"] as? Bool
            
            else { return nil }
        
        self.title = title
        self.major = major
        self.minor = minor
        self.strength = strength
        self.shouldTrigger = shouldTrigger
        
    }
    
    func isInRange(rssi:Int) -> Bool { return rssi > strength.rawValue }
    
}
