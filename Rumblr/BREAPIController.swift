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
    case serverError(description:String)
    
    var description:String {
        
        switch self {
            
        case .unknownError: return "Unknown error occured."
        case .serverError(let description): return description
            
        }
        
    }
    
}

enum BREAPIRequest {
    
    case searchSpotify(query:String)
    case requestSpotifyTrack(trackId:String)
    
    var path:String {
        
        switch self {
            
        case .searchSpotify(let query): return "/spotify/search/\(query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)"
        case .requestSpotifyTrack(let trackId): return "/spotify/play/\(trackId.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)"
            
        }
        
    }
    
    var method:String {
        
        switch self {
            
        case .requestSpotifyTrack(_): return "POST"
        default: return "GET"
        
        }
        
    }
}

class BREAPIController {

    class func performRequest(request:BREAPIRequest, completionBlock: @escaping (_ success:Bool, _ error:Error?, _ response: [String:Any]?) -> Void) {
        
        let url = URL(string: "\(BREServerRoot)\(request.path)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method

        let task = URLSession.shared.dataTask(with: urlRequest) { (data:Data?, response:URLResponse?, error:Error?) in
                        
            guard let data = data else { completionBlock(false, BREAPIError.unknownError, nil); return }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                let errorDescription = json?["error"] as? String
                
                completionBlock(errorDescription == nil, error != nil ? BREAPIError.serverError(description: errorDescription!) : nil, json)
                
            } catch (_) {
             
                completionBlock(false, BREAPIError.unknownError, nil)
                
            }
            
        }
        
        task.resume()
        
    }
    
}
