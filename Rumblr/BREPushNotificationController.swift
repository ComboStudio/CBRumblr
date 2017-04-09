//
//  BREPushNotificationController.swift
//  BeaconRangingExample
//
//  Created by Sam Piggott on 05/04/2017.
//  Copyright © 2017 Sam Piggott. All rights reserved.
//

import UIKit
import UserNotifications

class BREPushNotificationController: NSObject {

    class func requestPermissions() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (success:Bool, error:Error?) in
            
        }
        
    }
    
    class func createPushNotification(message:String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Beacon found!"
        content.body = message
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "1389402823904", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (err:Error?) in
            
            print("Done! Error: " + err.debugDescription)
            
        }
        
    }
    
}
