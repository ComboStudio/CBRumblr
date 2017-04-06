//
//  BRETrack.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BRETrack: NSObject, NSCoding {

    // Stored
    
    var title: String
    var artist: String
    var id: String
    var artworkURL: URL
    
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
    
    required init?(coder aDecoder: NSCoder) {
        
        guard
        let id = aDecoder.decodeObject(forKey: "id") as? String,
        let title = aDecoder.decodeObject(forKey: "title") as? String,
        let artworkURL = aDecoder.decodeObject(forKey: "artworkURL") as? URL,
            let artist = aDecoder.decodeObject(forKey: "artist") as? String else { return nil }
        
        self.id = id
        self.title = title
        self.artworkURL = artworkURL
        self.artist = artist
        
    }
    
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(artist, forKey: "artist")
        aCoder.encode(artworkURL, forKey: "artworkURL")
        
        
    }
    
}
