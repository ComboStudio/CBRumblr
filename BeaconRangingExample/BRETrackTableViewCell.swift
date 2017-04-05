//
//  BRETrackTableViewCell.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import SDWebImage

class BRETrackTableViewCell: UITableViewCell {

    static var cellIdentifier = "BRETrackTableViewCell"
    
    private var constraintsNeedUpdating = true
    private var track:BRETrack?
    
    private var albumArtImageView:UIImageView = {
       
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private var textContainer:UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private var titleLabel:UILabel = {
       
        let titleLabel = UILabel()
        titleLabel.font = UIFont.fontLight14
        titleLabel.text = "Track Name"
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
        
    }()
    
    private var subtitleLabel:UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.fontLight14
        titleLabel.text = "Artist Name"
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        textContainer.addSubview(titleLabel)
        textContainer.addSubview(subtitleLabel)
        
        contentView.addSubview(textContainer)
        contentView.addSubview(albumArtImageView)
        
        contentView.addSubview(textContainer)
        
        setNeedsUpdateConstraints()
        
    }

    
    func layout(track:BRETrack) {
        
        self.track = track
        
        DispatchQueue.main.async {
        
        self.titleLabel.text = track.title
        self.subtitleLabel.text = track.artist
        self.albumArtImageView.sd_setImage(with: track.artworkURL) { (image:UIImage?, err:Error?, cacheType:SDImageCacheType, url:URL?) in
            
            print("Finished adding!")
            
        }
            
        }
        
    }

    override func updateConstraints() {
        
        if constraintsNeedUpdating {
            
            let viewsDict:[String:Any] = ["titleLabel":titleLabel, "subtitleLabel":subtitleLabel, "textContainer":textContainer, "albumArtImageView":albumArtImageView]
            let metricsDict:[String:Any] = ["xEdgePadding":25, "yEdgePadding":14]
            
            textContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            textContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subtitleLabel]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            textContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel]-5-[subtitleLabel]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            
            contentView.addConstraint(NSLayoutConstraint(item: albumArtImageView, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 0.13, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: albumArtImageView, attribute: .height, relatedBy: .equal, toItem: self.albumArtImageView, attribute: .width, multiplier: 1.0, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: albumArtImageView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: 0))
            
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textContainer]|", options: [], metrics: metricsDict, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[albumArtImageView]-13-[textContainer]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateConstraints()
        
    }
    
    // MARK: Unrequired Functions
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
