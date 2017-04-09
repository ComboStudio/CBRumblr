//
//  BRESelectTrackPushTransition.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 09/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRESelectTrackPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let transitionDuration:TimeInterval = 1.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return transitionDuration
        
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? BRESelectTrackViewController
            else { transitionContext.completeTransition(true); return }
        
        let containerView = transitionContext.containerView
        
        fromVC.view.frame = transitionContext.initialFrame(for: fromVC)
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        containerView.addSubview(toVC.view)
        
        // View setup
        
        fromVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        fromVC.view.alpha = 1.0

        toVC.view.alpha = 0.0
        
        UIView.animate(withDuration: transitionDuration/2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            
            fromVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            fromVC.view.alpha = 0.0
            
        }, completion: nil)
        
        UIView.animate(withDuration: transitionDuration/2, delay: transitionDuration/4, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            
            toVC.view.alpha = 1.0
            
        }) { (complete:Bool) in
            
            // Reset previous view
            
            fromVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            fromVC.view.alpha = 1.0
            
            transitionContext.completeTransition(true)
            
        }
        
        
    }
    
}
