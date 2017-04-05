//
//  BRETrack.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRETrack: NSObject {

    // Stored
    
    var title: String
    var artist: String
    var id: String
    var artworkURL: URL
    
    // Generated
    
    var jsonData:Data {
        
        let obj = [
            
            "id": self.id,
            "title": self.title,
            "artist": self.artist,
            "artworkURL": self.artworkURL.absoluteString
            
        ]
        
        return try! JSONSerialization.data(withJSONObject: obj, options: [])
        
    }
    
    init?(dictionary:[String:Any]) {
        
        guard
        let id = dictionary["id"] as? String,
        let title = dictionary["name"] as? String,
        let artist = (dictionary["artists"] as? [[String:Any]])?.first?["name"] as? String,
        let images = (dictionary["album"] as? [String:Any])?["images"] as? [[String:Any]],
            let _artworkURL = images.first?["url"] as? String,
            let artworkURL = URL(string: _artworkURL) else { return nil }
    
        self.id = id
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
        
        
    }
    
    
    
}
