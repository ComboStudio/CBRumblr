//
//  ViewController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 29/03/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    func fetchBeacons() {
        
        let url = Bundle.main.url(forResource: "beacons", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        let _beaconsArray = dictionary["beacons"] as! [[String:Any]]
        let beaconsArray = _beaconsArray.map { return BREBeacon(dictionary: $0) }
        
        // Location
                
        BRELocationManager.shared.monitorBeacons(beacons: beaconsArray)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBeacons()
        
    }

}
