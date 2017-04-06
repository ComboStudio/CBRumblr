//
//  BREBeaconRegion.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 06/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import CoreLocation

class BREBeaconRegion: NSObject {

    var uuid:UUID
    var identifier:String
    var beacons:[BREBeacon]?
    
    var region:CLBeaconRegion {
        
        return CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
        
    }
    
    init?(dictionary:[String:Any]) {
        
        guard
        let uuidString = dictionary["uuid"] as? String,
        let uuid = UUID(uuidString: uuidString),
            let identifier = dictionary["identifier"] as? String else { return nil }
        
        self.uuid = uuid
        self.identifier = identifier
        self.beacons = {
           
            guard let beaconsArray = dictionary["beacons"] as? [[String:Any]] else { return nil }
            return beaconsArray.flatMap { BREBeacon(dictionary: $0) }
            
        }()
        
        
    }
    
}
