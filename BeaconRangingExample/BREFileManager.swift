//
//  BREFileManager.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit

class BREFileManager {

    static let documentsDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    class func saveFile(name:String, data:Data) throws {
        
        // TODO: Forcing everything. This is really bad!
        
        let url = URL(fileURLWithPath: documentsDirectory + "/" + name)
        
        // Check for existing file
        
        if FileManager.default.fileExists(atPath: url.absoluteString) == false {
         
            // Create new file if it doesn't exist
            
            FileManager.default.createFile(atPath: url.absoluteString, contents: nil, attributes: nil)
            print("Created new file at \(url.absoluteString)")
            
        }
        
        try! data.write(to: url)
        print("Written successfully to " + url.absoluteString)
        
        
    }
    
    class func fetchFile(name:String) -> Data? {
        
        let path = documentsDirectory + "/" + name
        
        if FileManager.default.fileExists(atPath: path) == false { return nil }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path))
        
    }
    
}
