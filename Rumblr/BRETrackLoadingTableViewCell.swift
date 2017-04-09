//
//  BRETrackLoadingTableViewCell.swift
//  Rumblr
//
//  Created by Sam Piggott on 09/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRETrackLoadingTableViewCell: UITableViewCell {
    
    static var cellIdentifier = "BRETrackLoadingTableViewCell"
    
    private var constraintsNeedUpdating = true
    
    private var statusIndicator:UIActivityIndicatorView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        
        statusIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        statusIndicator.startAnimating()
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(statusIndicator)
        
        setNeedsUpdateConstraints()
        
    }
    
    override func updateConstraints() {
        
        if constraintsNeedUpdating == true {
            
            contentView.addConstraint(NSLayoutConstraint(item: statusIndicator, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: statusIndicator, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: statusIndicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
            contentView.addConstraint(NSLayoutConstraint(item: statusIndicator, attribute: .height, relatedBy: .equal, toItem: statusIndicator, attribute: .width, multiplier: 1.0, constant: 0))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateConstraints()
        
    }
    
    override func prepareForReuse() {
        
        statusIndicator.startAnimating()
        
    }
    
    // MARK: Unrequired Function
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
