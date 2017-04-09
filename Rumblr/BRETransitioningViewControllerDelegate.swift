//
//  BRETransitioningViewControllerDelegate.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 09/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRETransitioningViewControllerDelegate: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // New Connection
        
        if fromVC is BREHomeViewController && toVC is BRESelectTrackViewController { return BRESelectTrackPushTransition() }
        
        return nil
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return nil
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return nil
        
    }
    
    
}
