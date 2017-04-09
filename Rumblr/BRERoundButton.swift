//
//  BRERoundButton.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRERoundButton: UIButton {

    init() {
        
        super.init(frame: .zero)
    
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        
        titleLabel?.font = UIFont.fontBold12
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
    }
    
    // MARK: Unrequired Functions
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
