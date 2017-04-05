//
//  BREAPIController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

enum BREAPIError:Error {
    
    case unknownError
    
}

enum BREAPIRequest {
    
    case requestSpotifyTrack(trackId:String)
    
    var path:String {
        
        switch self {
            
        case .requestSpotifyTrack(let trackId): return "/play/spotify/\(trackId)"
            
        }
        
    }
    
    var method:String {
        
        switch self {
            
        case .requestSpotifyTrack(_): return "POST"
            
        }
        
    }
}

class BREAPIController {

    class func performRequest(request:BREAPIRequest, completionBlock: @escaping (_ success:Bool, _ error:Error?, _ response: [String:Any]?) -> Void) {
        
        let url = URL(string: "\(BREServerRoot)\(request.path)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method

        let task = URLSession.shared.dataTask(with: urlRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            
            print(response)
            print(error)
            
            print("Firing for URL: " + url.absoluteString)
            
            guard let data = data else { completionBlock(false, BREAPIError.unknownError, nil); return }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                completionBlock(true, nil, json)
                
            } catch (_) {
             
                completionBlock(false, BREAPIError.unknownError, nil)
                
            }
            
        }
        
        task.resume()
        
    }
    
}
