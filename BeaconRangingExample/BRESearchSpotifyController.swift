//
//  BRESearchSpotifyController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

enum BRESpotifyError:Error {
    
    case unknown
    
}

enum BRESearchType:String {
    
    case track = "track"
    case album = "album"
    case artist = "artist"
    
}

enum BRESpotifyRequest {
    
    case search(term:String, type:BRESearchType)
    
    var path:String {
        
        switch self {
            
        case .search(_): return "/search"
            
        }
        
    }
    
    var queryItems:[URLQueryItem] {
        
        switch self {
            
        case .search(let term, let type): return [URLQueryItem(name:"type", value: type.rawValue), URLQueryItem(name: "q", value: term)]
            
        }
        
    }
    
    
}

class BRESearchSpotifyController {
    
    func performRequest(request:BRESpotifyRequest, completionBlock: @escaping (_ success:Bool, _ error:Error?, _ response:[String:Any]?) -> Void) {
        
        guard var urlComponents = URLComponents(string: BRESpotifyRoot.absoluteString + request.path) else { return }
        urlComponents.queryItems = request.queryItems
        guard let url = urlComponents.url else { return }
        
        print(url)

        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data:Data?, response:URLResponse?, err:Error?) in
            
            do {
                
                guard let data = data else { throw BRESpotifyError.unknown }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { throw BRESpotifyError.unknown }
                completionBlock(true, nil, json)
                
                
            }
            catch let error {
                
                print(error)
                
                
                completionBlock(false, error, nil)
                
            }
            
        }
        
        task.resume()
        
    }
    
}
