//
//  UserAuthorization.swift
//  SAGE
//
//  Created by Chris Zielinski on 2/2/17.
//  Copyright © 2017 Cal Blueprint. All rights reserved.
//

import Foundation
import UserNotifications

class UserAuthorization {
    
    class func userNotificationAllowed() -> Bool {
        
        let userSchool = SAGEState.currentSchool()?.name
        
        if userSchool != nil && userSchool!.containsString("UC Berkeley") {
            return false
        } else {
            return true
        }
        
    }
    
    class func userNotificationSwitchState(settingSwitch: UISwitch) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().getNotificationSettingsWithCompletionHandler() {
                (settings) in
                
                let preference = SAGEState.locationNotificationPreferenceInt()
                
                // true = 2, false = 1, not set = 0
                if (preference == 2 && settings.authorizationStatus == .Authorized) {
                    print("Notification switch state is on")
                    dispatch_async(dispatch_get_main_queue(),{
                        settingSwitch.setOn(true, animated: true)
                    })
                } else {
                    print("Notification switch state is off")
                    dispatch_async(dispatch_get_main_queue(),{
                        settingSwitch.setOn(false, animated: true)
                    })
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    class func userNotificationInitialAuthorization() {
        
        if #available(iOS 10.0, *) {
             let authorizationState = SAGEState.locationNotificationPreferenceInt()
            if (authorizationState == 0) {
                print("First application launch")
                UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Alert, .Sound]) {
                    (granted, error) in
                    if (granted) {
                        SAGEState.setLocationNotification(true)
                        // CREATE NOTIFICATION
                    } else {
                        SAGEState.setLocationNotification(false)
                    }
                }
            }
        }
        
    }
    
    class func userNotificationCheckAuthorization(presentingViewController VC: UIViewController, settingSwitch: UISwitch? = nil) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().getNotificationSettingsWithCompletionHandler() {
                (settings) in
                switch (settings.authorizationStatus) {
                case .NotDetermined:
                    print("Not determined")
                    UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Alert, .Sound]) {
                        (granted, error) in
                        if (granted) {
                            SAGEState.setLocationNotification(true)
                            // CREATE NOTIFICATION
                        } else {
                            SAGEState.setLocationNotification(false)
                            settingSwitch?.setOn(false, animated: true)
                        }
                    }
                case .Denied:
                    print("Denied")
                // Alert with instructions
                    let deniedAlert = UIAlertController(title: "Uh Oh.", message: "We're not authorized to send you notifications. You'll have to authorize us in your device's settings.", preferredStyle: .Alert)
                    
                    let settingsAction = UIAlertAction(title: "Go to settings", style: .Default) { (_) -> Void in
                        let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                        if let url = settingsUrl {
                            UIApplication.sharedApplication().openURL(url)
                        }
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                        (alert: UIAlertAction!) -> Void in
                        settingSwitch?.setOn(false, animated: true)
                    })
                    
                    deniedAlert.addAction(settingsAction)
                    deniedAlert.addAction(cancelAction)
                    
                    VC.presentViewController(deniedAlert, animated: true, completion: nil)
                default:
                    break
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
}
