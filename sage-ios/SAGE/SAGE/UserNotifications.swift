//
//  UserNotifications.swift
//  SAGE
//
//  Created by Chris Zielinski on 2/2/17.
//  Copyright © 2017 Cal Blueprint. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class UserNotifications: NSObject {
    
    class func launch() {
        print("LAUNCH")
        if #available(iOS 10.0, *) {
            if (UserAuthorization.userNotificationAllowed()) {
                self.removeAllPendingNotifications()
                self.createLocationNotification(presentingViewController: RootController.sharedController())
            }
//            UNUserNotificationCenter.currentNotificationCenter().getNotificationCategoriesWithCompletionHandler() {
//                (categories) in
//                if (categories.isEmpty) {
//                    print("Categories are empty. Setting them now.")
//                    let beginAction = UNNotificationAction(identifier: NotificationConstants.beginSessionActionID, title: "Begin Session", options: [])
//                    //                        let remindAction = UNNotificationAction(identifier: NotificationConstants.remindActionID, title: "Remind me in 5 minutes", options: [])
//                    let category = UNNotificationCategory(identifier: NotificationConstants.locationCategoryID, actions: [beginAction], intentIdentifiers: [], options: [])
//                    UNUserNotificationCenter.currentNotificationCenter().setNotificationCategories([category])
//                }
//                if (UserAuthorization.userNotificationAllowed()) {
//                    UNUserNotificationCenter.currentNotificationCenter().getPendingNotificationRequestsWithCompletionHandler() {
//                        (notifications) in
//                        if (notifications.isEmpty) {
//                            self.createLocationNotification(presentingViewController: RootController.sharedController())
//                        }
//                    }
//                }
//            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    /**
     Not applicable to this release. Still learing how to use git :)
     */
    class func setup() {
//        print("SETUP")
//        if (UserAuthorization.userNotificationAllowed()) {
//            if #available(iOS 10.0, *) {
//                UNUserNotificationCenter.currentNotificationCenter().getNotificationCategoriesWithCompletionHandler() {
//                    (categories) in
//                    print("Set categories: \(categories)")
//                    if (categories.isEmpty) {
//                        print("Categories are empty. Setting them now.")
//                        let beginAction = UNNotificationAction(identifier: NotificationConstants.beginSessionActionID, title: "Begin Session", options: [])
////                        let remindAction = UNNotificationAction(identifier: NotificationConstants.remindActionID, title: "Remind me in 5 minutes", options: [])
//                        let category = UNNotificationCategory(identifier: NotificationConstants.locationCategoryID, actions: [beginAction], intentIdentifiers: [], options: [])
//                        UNUserNotificationCenter.currentNotificationCenter().setNotificationCategories([category])
//                    }
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//        }
    }
    
    class func createLocationNotification(presentingViewController VC: UIViewController) {
        print("CREATING A LOCATION NOTIFICATION")
        if (UserAuthorization.userNotificationAllowed()) {
            self.setup()
            if #available(iOS 10.0, *) {
                guard let school = SAGEState.currentSchool(), location = school.location, name = school.name else {
                    let errorAlert = UIAlertController(title: "Uh Oh.", message: "We encountered an error while creating your location notification. (EC1)", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                    errorAlert.addAction(cancelAction)
                    VC.presentViewController(errorAlert, animated: true, completion: nil)
                    return
                }
                
//                UNUserNotificationCenter.currentNotificationCenter().getNotificationCategoriesWithCompletionHandler() { (categories) in
//                    print("Set categories inside create notification: \(categories)\n")
//                }
                
                let entryContent = UNMutableNotificationContent()
                entryContent.title = "Hi, \(SAGEState.currentUser()!.firstName!)!"
                entryContent.subtitle = "Looks like you're getting close to \(name)."
                entryContent.body = "Don't forget to begin your session."
                entryContent.sound = UNNotificationSound.defaultSound()
//                entryContent.categoryIdentifier = NotificationConstants.locationCategoryID
                
                let exitContent = UNMutableNotificationContent()
                exitContent.title = "Hi again, \(SAGEState.currentUser()!.firstName!)!"
                exitContent.subtitle = "Looks like you're leaving \(name)."
                exitContent.body = "Don't forget to finish your session."
                exitContent.sound = UNNotificationSound.defaultSound()
//                exitContent.categoryIdentifier = NotificationConstants.locationCategoryID
                
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 45, repeats: false)
                let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                
                let entryRegion = CLCircularRegion(center: center, radius: school.radius, identifier: NotificationConstants.locationEntryRegionID)
                entryRegion.notifyOnEntry = true
                entryRegion.notifyOnExit = false
                
                let exitRegion = CLCircularRegion(center: center, radius: school.radius, identifier: NotificationConstants.locationExitRegionID)
                exitRegion.notifyOnEntry = false
                exitRegion.notifyOnExit = true
                
                let entryTrigger = UNLocationNotificationTrigger(region: entryRegion, repeats: true)
                let entryRequest = UNNotificationRequest(identifier: NotificationConstants.locationEntryNotificationID, content: entryContent, trigger: entryTrigger)
                
                // TODO: Not implemented
                let exitTrigger = UNLocationNotificationTrigger(region: exitRegion, repeats: true)
                let exitRequest = UNNotificationRequest(identifier: NotificationConstants.locationExitNotificationID, content: exitContent, trigger: exitTrigger)
                
                UNUserNotificationCenter.currentNotificationCenter().addNotificationRequest(entryRequest) {
                    (error) in
                    print("NOTIFICATION SCHEDULED")
                    if error != nil {
                        let errorAlert = UIAlertController(title: "Uh Oh.", message: "We encountered an error while creating your location notification. (EC2)", preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                        errorAlert.addAction(cancelAction)
                        VC.presentViewController(errorAlert, animated: true, completion: nil)
                    }
                }
            } else {
                // Fallback
            }
            
        }
    }
    
    class func removeAllPendingNotifications() {
        print("REMOVING ALL NOTIFICATIONS")
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().removeAllPendingNotificationRequests()
        } else {
            // Fallback
        }
    }
    
}
