//
//  BREGradientView.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 09/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BREGradientView: UIView {
    
    private var gradientLayer:CAGradientLayer!
    private var topColour:UIColor!
    private var bottomColour:UIColor!
    private var hasLaidOut:Bool = false
    
    init(topColour:UIColor, bottomColour:UIColor) {
        
        super.init(frame: .zero)
        
        self.topColour = topColour
        self.bottomColour = bottomColour
     
    }
    
    private func setupGradient() {
        
        // Gradient
        
        gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.25, 0.95, 1]
        gradientLayer.colors = [topColour.cgColor, bottomColour.cgColor]
        gradientLayer.frame = self.bounds
        
        layer.addSublayer(gradientLayer)
        
    }
    
    override func layoutSublayers(of layer: CALayer) {
        
        super.layoutSublayers(of: layer)
        
        if (hasLaidOut == false && bounds.size.width > 0) {
        
            setupGradient()
            hasLaidOut = true
            
        }
        
    }
    
    // MARK: Unrequired Functions
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
