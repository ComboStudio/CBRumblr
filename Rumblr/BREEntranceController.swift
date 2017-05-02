//
//  BREEntranceController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BREEntranceController: NSObject {
    
    static var shared:BREEntranceController = BREEntranceController()
    private var _activeTrack:BRETrack?
    var activeTrack:BRETrack? {
        
        get {
            
            if _activeTrack == nil {
                
                guard let data = BREFileManager.fetchFile(name: BRETrackFileName) else { print("Couldn't fetch file"); return nil }
                guard let track = NSKeyedUnarchiver.unarchiveObject(with: data) as? BRETrack else { print("Couldn't unarchive object"); return nil }
                
                _activeTrack = track
                
            }
            
            return _activeTrack
            
        }
        
        
    }
    
    func updateTrack(track:BRETrack) throws {
        
        _activeTrack = nil
        try? BREFileManager.saveFile(name: BRETrackFileName, data: NSKeyedArchiver.archivedData(withRootObject: track))
        
        
    }
    
    func makeEntrance(completionBlock:@escaping (_ success:Bool) -> Void) {
        
        // Should this fire? Check that we're armed before we actually start playing tracks like crazy...
        
        // Check to make sure the track even exists...
        
        guard let activeTrack = activeTrack else { return }
        
        BREAPIController.performRequest(request: BREAPIRequest.requestSpotifyTrack(trackId: activeTrack.id)) { (success:Bool, error:Error?, response:[String : Any]?) in
            
            // Check for errors...
            
            if (error != nil) {
                
                // Shit, something bad's happened. This probably means that the track didn't play, so we'll need to make sure we handle this in the UI. Because we've hacked this together in the space of 24 hours, however, I've been lazy and done nothing about this.
                
            }
                
            else {
                
                // Alright! Everything went as expected, the tune should be playing over the Sonos! We've had our fun. Disarm, otherwise this'll keep going off like crazy.
                
            }
            
            completionBlock(success)
            
        }
        
    }
}
