//
//  BREBluetoothController.swift
//  Rumblr
//
//  Created by Sam Piggott on 10/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import CoreBluetooth

class BREBluetoothController: NSObject {

    fileprivate var completionBlock: ((_ isEnabled:Bool) -> Void)?
    fileprivate lazy var bluetoothManager:CBCentralManager = CBCentralManager(delegate: self, queue: nil)
    
    func checkIfBluetoothIsEnabled(completionBlock: @escaping (_ isEnabled:Bool) -> Void) {
        
        bluetoothManager.scanForPeripherals(withServices: nil, options: nil)
        
        self.completionBlock = completionBlock
        
    }
    
}

extension BREBluetoothController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
                
        completionBlock?(central.state == .poweredOn)
        
        self.completionBlock = nil
        
    }
    
}
