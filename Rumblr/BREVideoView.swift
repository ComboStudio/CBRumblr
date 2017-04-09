//
//  BREVideoView.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 09/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import AVFoundation

class BREVideoView: UIView {

    private var constraintsNeedUpdating = true
    
    private lazy var videoContainer:UIView = {
        
        let videoView = UIView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
        
    }()
    
    private lazy var player:AVPlayer = {
        
        let player = AVPlayer()
        player.isMuted = true
        player.allowsExternalPlayback = false
        return player
        
    }()
    
    private lazy var playerLayer:AVPlayerLayer = {
        
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return playerLayer
        
    }()
    
    init() {
        
        super.init(frame: CGRect.zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BREVideoView.playerReachedEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        addSubview(videoContainer)
        
        videoContainer.layer.addSublayer(playerLayer)
        
        setNeedsUpdateConstraints()
        
    }
    
    override func updateConstraints() {
        
        if constraintsNeedUpdating {
            
            let metricsDict:[String:AnyObject] = [:]
            let viewsDict:[String:AnyObject] = ["videoContainer":videoContainer]
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[videoContainer]|", options: NSLayoutFormatOptions(), metrics: metricsDict, views: viewsDict))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[videoContainer]|", options: [], metrics: metricsDict, views: viewsDict))
            
            constraintsNeedUpdating = false
            
        }
        
        super.updateConstraints()
        
    }
    
    func set(url:URL) {
        
        let asset = AVAsset(url: url)
        let videoItem = AVPlayerItem(asset: asset)
        self.player.replaceCurrentItem(with: videoItem)
        
        DispatchQueue.main.async {
         
            self.playerLayer.frame = self.videoContainer.bounds
            self.player.play()
            
        }
        
    }
    
    func playerReachedEnd(_ notification:Notification) {
        
        guard let object = notification.object as? AVPlayerItem else { return }
        if object == player.currentItem {
            player.seek(to: kCMTimeZero)
            player.play()
        }
        
    }
    
    // MARK: Unrequired Functions
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
