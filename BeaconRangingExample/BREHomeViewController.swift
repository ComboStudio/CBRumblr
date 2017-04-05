//
//  BREHomeViewController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BREHomeViewController: UIViewController {

    private var constraintsNeedUpdating = true
    
    private lazy var entranceTrackTitleLabel:UILabel = {
       
        let label = UILabel()
        label.text = "Your Entrance Music".uppercased()
        label.font = UIFont.fontBold12
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private lazy var albumArtImageView:UIImageView = {
       
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedAlbumArtwork))
        
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gestureRecognizer)
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private lazy var trackTextContainer:UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private lazy var trackTitleLabel:UILabel = {
        
        let label = UILabel()
        label.text = "Example Text"
        label.font = UIFont.fontLight26
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private lazy var trackSubtitleLabel:UILabel = {
        
        let label = UILabel()
        label.text = "Example Artist Name".uppercased()
        label.font = UIFont.fontBold12
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private lazy var separatorLine:UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private lazy var buttonContainer:UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()

    
    private lazy var buttonChangeItUp:BRERoundButton = {
       
        let button = BRERoundButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Change it up".uppercased(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var buttonTurnItUp:BRERoundButton = {
        
        let button = BRERoundButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Turn it up".uppercased(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trackTextContainer.addSubview(trackTitleLabel)
        trackTextContainer.addSubview(trackSubtitleLabel)
        
        buttonContainer.addSubview(buttonChangeItUp)
        buttonContainer.addSubview(buttonTurnItUp)
        
        view.addSubview(entranceTrackTitleLabel)
        view.addSubview(albumArtImageView)
        view.addSubview(trackTextContainer)
        view.addSubview(separatorLine)
        view.addSubview(buttonContainer)
        
        view.setNeedsUpdateConstraints()
        
    }

    
    override func updateViewConstraints() {
        
        if constraintsNeedUpdating {
            
            let viewsDict:[String:Any] = ["buttonContainer":buttonContainer, "buttonTurnItUp":buttonTurnItUp, "buttonChangeItUp":buttonChangeItUp, "separatorLine":separatorLine, "trackSubtitleLabel":trackSubtitleLabel, "trackTitleLabel":trackTitleLabel, "trackTextContainer":trackTextContainer, "albumArtImageView":albumArtImageView, "entranceTrackTitleLabel":entranceTrackTitleLabel]
            let metricsDict:[String:Any] = ["xEdgePadding":25, "buttonHeight":40]
            
            buttonContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[buttonChangeItUp]-25-[buttonTurnItUp]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            buttonContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[buttonChangeItUp]|", options: [], metrics: metricsDict, views: viewsDict))
            buttonContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[buttonTurnItUp]|", options: [], metrics: metricsDict, views: viewsDict))
            
            trackTextContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[trackTitleLabel]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            trackTextContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[trackSubtitleLabel]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            trackTextContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[trackTitleLabel]-10-[trackSubtitleLabel]|", options: [], metrics: metricsDict, views: viewsDict))
            
            view.addConstraint(NSLayoutConstraint(item: albumArtImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: albumArtImageView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.86, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: albumArtImageView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0))
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[entranceTrackTitleLabel]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[trackTextContainer]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[separatorLine]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[buttonContainer]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[entranceTrackTitleLabel]-20-[albumArtImageView]-(<=46)-[trackTextContainer]-10-[separatorLine(1)]-24-[buttonContainer(==buttonHeight)]-37-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateViewConstraints()
        
    }
    
    // MARK: User Interactions
    
    func tappedAlbumArtwork() {
        
        navigationController?.pushViewController(BRESelectTrackViewController(), animated: true)
        
    }

}
