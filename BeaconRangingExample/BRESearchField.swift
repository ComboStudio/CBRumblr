//
//  BRESearchInput.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRESearchField: UIView {

    private var constraintsNeedUpdating = true
    
    var textField:UITextField = {
       
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.fontRegular14
        textField.attributedPlaceholder = NSAttributedString(string: "Enter a song name...", attributes: [NSFontAttributeName:UIFont.fontLight14, NSForegroundColorAttributeName:UIColor.white.withAlphaComponent(0.5)])
        textField.textColor = UIColor.white
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
        
    }()
    
    init() {
        
        super.init(frame: .zero)
        
        isUserInteractionEnabled = true
        
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        
        addSubview(textField)
        
        setNeedsUpdateConstraints()
        
    }

    override func updateConstraints() {
        
        if constraintsNeedUpdating {
            
            let viewsDict:[String:Any] = ["textField":textField]
            let metricsDict:[String:Any] = ["xEdgePadding":22, "yEdgePadding":12]
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[textField]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-yEdgePadding-[textField(25)]-yEdgePadding-|", options: [], metrics: metricsDict, views: viewsDict))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateConstraints()
        
    }
    
    // MARK: Unrequired Functions
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
