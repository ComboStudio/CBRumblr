//
//  BREScanningViewController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 06/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BREScanningViewController: UIViewController {

    private lazy var locationManager:BRELocationManager = {
        
        let locationManager = BRELocationManager()
        locationManager.delegate = self
        return locationManager
        
    }()
    
    private var constraintsNeedUpdating = true
    
    private var activityIndicator:UIActivityIndicatorView = {
      
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
        view.addSubview(activityIndicator)
        
        view.setNeedsUpdateConstraints()
        
        locationManager.beginMonitoring()
        
    }
    
    override func updateViewConstraints() {
        
        if constraintsNeedUpdating {
            
            view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
            view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateViewConstraints()
        
    }

}

extension BREScanningViewController: BRELocationManagerDelegate {
    
    func beaconFound(beacon: BREBeacon) {
                
        dismiss(animated: true, completion: nil)
        
        BREEntranceController.shared.makeEntrance()
        
    }
    
    func beaconNotFound() {
        
        print("Not found")
        
    }
    
}
