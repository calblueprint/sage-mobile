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
    
    /**
     Location notifications are off if not assigned to a valid school.
     @return whether the switch should be grayed out (disabled) or enabled.
    */
    class func userNotificationSwitchEnabled() -> Bool {
        let userSchool = SAGEState.currentSchool()?.name
        if userSchool != nil && userSchool!.containsString("UC Berkeley") && !StringConstants.debug {
            return false
        } else {
            return true
        }
    }
    
    /**
     @return whether the user has enabled location notifications
     */
    class func userNotificationAllowed() -> Bool {
        
        let preference = SAGEState.locationNotificationPreferenceInt()
        
        if (userNotificationSwitchEnabled() && preference == 2) {
            return true
        } else {
            return false
        }
    }
    
    /**
     Pass in the switch, handles the rest
     @param settingSwitch the UISwitch to assign a state to
     */
    class func setUserNotificationSwitchState(settingSwitch: UISwitch) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().getNotificationSettingsWithCompletionHandler() {
                (settings) in
                
                let preference = SAGEState.locationNotificationPreferenceInt()
                
                // true = 2, false = 1, not set = 0
                if (preference == 2 && settings.authorizationStatus == .Authorized) {
                    dispatch_async(dispatch_get_main_queue(),{
                        settingSwitch.setOn(true, animated: true)
                    })
                } else {
                    UserNotifications.removeAllPendingNotifications()
                    dispatch_async(dispatch_get_main_queue(),{
                        settingSwitch.setOn(false, animated: true)
                    })
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    /**
     Presents notification authorization dialog to user if it's the app's first launch.
     Can be called at every app launch.
     */
    class func userNotificationInitialAuthorization() {
        
        if #available(iOS 10.0, *) {
             let authorizationState = SAGEState.locationNotificationPreferenceInt()
            if (authorizationState == 0) {
                UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Alert, .Sound]) {
                    (granted, error) in
                    if (granted) {
                        // CREATE NOTIFICATION
                        SAGEState.setLocationNotification(true)
                    } else {
                        SAGEState.setLocationNotification(false)
                    }
                }
            }
        }
        
    }
    
    /**
     Checks the app's notification authorization. Presents system authorization dialog if auth state is not determined.
     Presents alert linking to app's settings if auth state is denied. To be used when user interacts with a notification function
     in the app (e.g. user turns on location notifications, app needs to ensure it has proper auth)
     */
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
                            // CREATE NOTIFICATION
                            SAGEState.setLocationNotification(true)
                        } else {
                            SAGEState.setLocationNotification(false)
                            dispatch_async(dispatch_get_main_queue(),{
                                settingSwitch?.setOn(false, animated: true)
                            })
                        }
                    }
                case .Denied:
                    print("Denied")
                    SAGEState.setLocationNotification(false)
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
                        dispatch_async(dispatch_get_main_queue(),{
                            settingSwitch?.setOn(false, animated: true)
                        })
                    })
                    
                    deniedAlert.addAction(settingsAction)
                    deniedAlert.addAction(cancelAction)
                    
                    VC.presentViewController(deniedAlert, animated: true, completion: nil)
                default:
                    SAGEState.setLocationNotification(true)
                    break
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
}
