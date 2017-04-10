//
//  BREScanningViewController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 06/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

enum BREScanningCompletionState {
    
    case success
    case failed(error:String?)
    
    var titleText:String {
        
        switch self {
            
        case .success: return "Get out there!"
        case .failed: return "Ah, jeez."
            
        }
        
    }
    
    var supportingText:String {
        
        switch self {
            
        case .success: return "Music's cued up. They're ready for you!"
        case .failed(let error): return error ?? "Looks like you're not close enough to the entrance right now."
            
        }
        
    }
    
    var backgroundColour:UIColor {
        
        switch self {
            
        case .success: return UIColor.hexStringToUIColor(hex: "2EC83A")
        case .failed: return UIColor.hexStringToUIColor(hex: "C82E2E")
            
        }
        
    }
    
}

class BREScanningViewController: UIViewController {
    
    private var constraintsNeedUpdating = true
    override var prefersStatusBarHidden: Bool { return true }

    fileprivate lazy var locationManager:BRELocationManager = {
        
        let locationManager = BRELocationManager()
        locationManager.delegate = self
        return locationManager
        
    }()

    private var closeButton:UIButton = {
       
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(BREScanningViewController.tappedCloseButton), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private var loadingView:UIView = {
       
        let view = UIView()
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private var loadingLabel:UILabel = {
        
        let label = UILabel()
        label.font = UIFont.fontBold12
        label.textAlignment = .center
        label.text = "Warming up the fans..."
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private var activityIndicator:UIActivityIndicatorView = {
      
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
        
    }()
    
    private var backgroundVideoView:BREVideoView = {
       
        let videoView = BREVideoView()
        videoView.alpha = 0.5
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
        
    }()
    
    private var completionView:UIView = {
        
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private var completionViewTextContainer:UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private var completionTitleLabel:UILabel = {
       
        let label = UILabel()
        label.font = UIFont.fontLight26
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private var completionSupportLabel:UILabel = {
        
        let label = UILabel()
        label.font = UIFont.fontRegular14
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.backgroundColor = .black
        
        completionViewTextContainer.addSubview(completionTitleLabel)
        completionViewTextContainer.addSubview(completionSupportLabel)
        
        completionView.addSubview(completionViewTextContainer)
        
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        
        view.addSubview(backgroundVideoView)
        view.addSubview(loadingView)
        view.addSubview(completionView)
        view.addSubview(closeButton)
                
        // Video View Setup
        
        view.setNeedsUpdateConstraints()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        let fileURLPath = Bundle.main.path(forResource: "audience", ofType: "mp4")!
        backgroundVideoView.set(url: URL(fileURLWithPath: fileURLPath))
                
        locationManager.beginMonitoring()
        
    }
    
    override func updateViewConstraints() {
        
        if constraintsNeedUpdating {
            
            let metricsDict:[String:Any] = ["xEdgePadding":25]
            let viewsDict:[String:Any] = ["activityIndicator":activityIndicator, "closeButton":closeButton, "completionTitleLabel":completionTitleLabel, "completionSupportLabel":completionSupportLabel, "completionView":completionView, "loadingView":loadingView, "loadingLabel":loadingLabel, "backgroundVideoView":backgroundVideoView, "completionViewTextContainer":completionViewTextContainer]
            
            loadingView.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.loadingView, attribute: .centerX, multiplier: 1.0, constant: 0))
            loadingView.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
            loadingView.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
            loadingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[loadingLabel]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            loadingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[activityIndicator]-10-[loadingLabel]|", options: [], metrics: metricsDict, views: viewsDict))
            
            completionViewTextContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[completionTitleLabel]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            completionViewTextContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[completionSupportLabel]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            completionViewTextContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[completionTitleLabel]-10-[completionSupportLabel]|", options: [], metrics: metricsDict, views: viewsDict))
            
            completionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[completionViewTextContainer]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            completionView.addConstraint(NSLayoutConstraint(item: completionViewTextContainer, attribute: .centerY, relatedBy: .equal, toItem: self.completionView, attribute: .centerY, multiplier: 1.0, constant: 0))
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[completionView]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[completionView]|", options: [], metrics: metricsDict, views: viewsDict))
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xEdgePadding-[loadingView]-xEdgePadding-|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            view.addConstraint(NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0))
            
            view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -20))
            view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 30))
            view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
            view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: self.closeButton, attribute: .width, multiplier: 1.0, constant: 0))
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundVideoView]|", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundVideoView]|", options: [], metrics: metricsDict, views: viewsDict))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateViewConstraints()
        
    }

    fileprivate func transitionTo(state:BREScanningCompletionState) {
        
        // Setup
        
        self.completionView.isHidden = false
        self.completionView.alpha = 0
        
        self.completionTitleLabel.text = state.titleText
        self.completionSupportLabel.text = state.supportingText
        self.completionView.backgroundColor = state.backgroundColour.withAlphaComponent(0.45)
        
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: {
            
            self.loadingView.alpha = 0
            
        }) { (done: Bool) in
            
            self.loadingView.isHidden = true
            
        }
        
        UIView.animate(withDuration: 0.65, delay: 0.35, options: [.curveEaseIn], animations: { 
            
            self.completionView.alpha = 1.0
            
        }, completion: nil)
        
    }
    
    // MARK: User Interaction
    
    func tappedCloseButton() {
        
        dismiss(animated: true, completion: nil)
        locationManager.stopMonitoring()
        
    }
    
}

extension BREScanningViewController: BRELocationManagerDelegate {
    
    func beaconDiscoveredNewBeacon(beacon: BREBeacon) {
        
        // Check that this beacon should trigger the music...
        
        guard beacon.shouldTrigger == true else { return }
        
        // It does! We're good to go.
        
        locationManager.stopMonitoring()
        
        // Make the entrance!
        
        BREEntranceController.shared.makeEntrance { [weak self] (success:Bool) in
            
            DispatchQueue.main.async {
            
                self?.transitionTo(state: success == true ? .success : .failed(error: nil))
            
            }
            
        }
        
    }
    
    func beaconOutOfRange(beacon: BREBeacon) {
        
        // This delegate method's simply for detecting if we leave the range of a beacon.
        
    }
    
    func beaconScanningFailed(error: BRELocationManagerError) {
        
        locationManager.stopMonitoring()
        
        transitionTo(state: .failed(error: error.description))
        
    }
    
}

