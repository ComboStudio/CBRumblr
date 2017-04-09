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

extension UIColor {
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static var colourLightBlue:UIColor { return UIColor.hexStringToUIColor(hex: "0cd2e6") }
}
