//
//  BREHomeViewController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import SDWebImage

class BREHomeViewController: UIViewController {
    
    private var constraintsNeedUpdating = true
    override var prefersStatusBarHidden: Bool { return true }
    
    private lazy var entranceTrackTitleLabel:UILabel = {
        
        let label = UILabel()
        label.text = "Your Entrance Music".uppercased()
        label.font = UIFont.fontBold12
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private lazy var albumArtImageView:BREImageView = {
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedAlbumArtwork))
        
        let imageView = BREImageView()
        imageView.set(image: #imageLiteral(resourceName: "placeholder"))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 10.0
        imageView.layer.shadowOpacity = 0.4
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
        
    }()
    
    private lazy var albumArtGradientView:BREGradientView = {
        
        let gradientView = BREGradientView(topColour: UIColor.black.withAlphaComponent(0.0), bottomColour: UIColor.black.withAlphaComponent(1.0))
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
        
    }()
    
    private lazy var albumArtTextLabel:UILabel = {
        
        let label = UILabel()
        label.text = "Change your entrance music"
        label.textAlignment = .center
        label.font = UIFont.fontBold12
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private lazy var trackTextContainer:UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private lazy var trackTitleLabel:UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.fontLight26
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private lazy var trackSubtitleLabel:UILabel = {
        
        let label = UILabel()
        label.text = "Select your entrance track by tapping the artwork above!"
        label.numberOfLines = 2
        label.font = UIFont.fontBold12
        label.textColor = UIColor.colourLightBlue
        label.textAlignment = .center
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
    
    
    private lazy var buttonReady:BRERoundButton = {
        
        let button = BRERoundButton()
        button.addTarget(self, action: #selector(BREHomeViewController.tappedReadyButton), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("I'm ready".uppercased(), for: .normal)
        
        // Initial state for this is deactivated, as the user won't have selected a track at this point. When the VC is updated with a track, it will be tappable!
        
        button.alpha = 0.3
        button.isUserInteractionEnabled = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackTextContainer.addSubview(trackTitleLabel)
        trackTextContainer.addSubview(trackSubtitleLabel)
        
        buttonContainer.addSubview(buttonReady)
        
        albumArtImageView.addSubview(albumArtGradientView)
        albumArtImageView.addSubview(albumArtTextLabel)
        
        view.addSubview(entranceTrackTitleLabel)
        view.addSubview(albumArtImageView)
        view.addSubview(trackTextContainer)
        view.addSubview(separatorLine)
        view.addSubview(buttonContainer)
        
        view.setNeedsUpdateConstraints()
        
        // Hide the status bar
        
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        layoutWithActiveTrack()
        animateIn()
        
    }
    
    func layoutWithActiveTrack() {
        
        guard let track = BREEntranceController.shared.activeTrack else { return }
        
        trackTitleLabel.text = track.title
        trackSubtitleLabel.text = track.artist.uppercased()
        albumArtImageView.set(url: track.artworkURL)
        buttonReady.isUserInteractionEnabled = true
        buttonReady.alpha = 1.0
        
    }
    
    func animateIn() {
        
        // Prepare
        
        self.entranceTrackTitleLabel.alpha = 0
        self.separatorLine.alpha = 0
        
        self.trackTextContainer.alpha = 0
        self.trackTextContainer.transform.ty = 20
        
        self.buttonContainer.alpha = 0
        self.buttonContainer.transform.ty = 20
        
        self.albumArtImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.albumArtImageView.alpha = 0
        
        // Artwork
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: {
            
            self.albumArtImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.albumArtImageView.alpha = 1
            
        }, completion: nil)
        
        // Buttons
        
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: {
            
            self.buttonContainer.transform.ty = 0
            self.buttonContainer.alpha = 1
            
        }, completion: nil)
        
        // Track text
        
        UIView.animate(withDuration: 0.65, delay: 0.15, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: {
            
            self.trackTextContainer.transform.ty = 0
            self.trackTextContainer.alpha = 1
            
        }, completion: nil)
        
        // And the rest.
        
        UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            
            self.entranceTrackTitleLabel.alpha = 1
            self.separatorLine.alpha = 1
            
        }, completion: nil)
        
        
    }
    
    override func updateViewConstraints() {
        
        if constraintsNeedUpdating {
            
            let viewsDict:[String:Any] = ["buttonContainer":buttonContainer, "buttonReady":buttonReady, "separatorLine":separatorLine, "trackSubtitleLabel":trackSubtitleLabel, "trackTitleLabel":trackTitleLabel, "trackTextContainer":trackTextContainer, "albumArtImageView":albumArtImageView, "entranceTrackTitleLabel":entranceTrackTitleLabel, "albumArtGradientView":albumArtGradientView, "albumArtTextLabel":albumArtTextLabel]
            let metricsDict:[String:Any] = ["xEdgePadding":25, "buttonHeight":40]
            
            albumArtImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[albumArtGradientView]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            albumArtImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[albumArtGradientView(80)]|", options: [], metrics: metricsDict, views: viewsDict))
            albumArtImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[albumArtTextLabel]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            albumArtImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[albumArtTextLabel]-20-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            
            buttonContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[buttonReady]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            buttonContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[buttonReady]|", options: [], metrics: metricsDict, views: viewsDict))
            
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
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[entranceTrackTitleLabel]-20-[albumArtImageView]-(<=46)-[trackTextContainer]-20-[separatorLine(1)]-24-[buttonContainer(==buttonHeight)]-37-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateViewConstraints()
        
    }
    
    // MARK: User Interactions
    
    func tappedAlbumArtwork() {
        
        navigationController?.pushViewController(BRESelectTrackViewController(), animated: true)
        
        
    }
    
    func tappedReadyButton() {
        
        navigationController?.present(BREScanningViewController(), animated: true, completion: nil)
    
    }
    
}
