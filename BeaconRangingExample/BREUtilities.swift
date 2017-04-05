//
//  BREUtilities.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import CoreLocation
import UIKit

extension CLRegionState {
    
    var description:String {
        
        switch self {
            
        case .inside: return "Inside"
        case .outside: return "Outside"
        case .unknown: return "Unknown"
            
        }
        
    }
    
}

extension UIFont {
    
    static var fontLight26:UIFont { return UIFont.systemFont(ofSize: 26.0) }
    static var fontBold12:UIFont { return UIFont.boldSystemFont(ofSize: 12.0) }
    static var fontRegular14:UIFont { return UIFont.systemFont(ofSize: 14.0) }
    static var fontLight14:UIFont { return UIFont.systemFont(ofSize: 14.0, weight: 0.2) }
    
}
