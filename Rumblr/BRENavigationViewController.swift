//
//  BRENavigationViewController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRENavigationViewController: UINavigationController {

    private var constraintsNeedUpdating = true
    
    private var transitionController = BRETransitioningViewControllerDelegate()
    
    private lazy var backgroundImageView:UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "backgroundImage")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isNavigationBarHidden = true
        interactivePopGestureRecognizer?.delegate = nil
        interactivePopGestureRecognizer?.isEnabled = true
        
        delegate = transitionController
        transitioningDelegate = transitionController
        
        view.insertSubview(backgroundImageView, at: 0)
        
        view.setNeedsUpdateConstraints()
    
    }
    
    override func updateViewConstraints() {
        
        if constraintsNeedUpdating {
            
            let viewsDict:[String:Any] = ["backgroundImageView":backgroundImageView]
            let metricsDict:[String:Any] = [:]
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: [], metrics: metricsDict, views: viewsDict))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateViewConstraints()
        
    }

}
