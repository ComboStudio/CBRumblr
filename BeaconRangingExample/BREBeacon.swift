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

class BREBeacon {
    
    var title:String
    var major:Int
    var minor:Int
    var strength:BREBeaconStrength
    
    init(dictionary:[String:Any]) {
        
        title = dictionary["beacon_name"] as! String
        
        major = dictionary["major"] as! Int
        minor = dictionary["minor"] as! Int
        strength = {
            
            let strengthInt = dictionary["strength"] as! Int
            return BREBeaconStrength(rawValue: strengthInt)!
            
        }()
        
    }
    
    func isInRange(rssi:Int) -> Bool { return rssi < strength.rawValue }
    
}
