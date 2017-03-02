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
        if (UserAuthorization.userNotificationAllowed()) {
            self.createLocationNotification()
        } else {
            UserAuthorization.userNotificationInitialAuthorization()
        }
    }
    
    class func askForPreference() {
        UserAuthorization.userNotificationCheckAuthorization() { () in
            let alertController = UIAlertController(
                title: "Let us remind you.",
                message: "Would you like us to remind you to begin your session when you're close to \(SAGEState.currentSchool() != nil ? SAGEState.currentSchool()!.name!.stringByReplacingOccurrencesOfString(" elementary school", withString: "", options: .CaseInsensitiveSearch, range: nil) : "your school?")",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) -> Void in
                SAGEState.setLocationNotification(true)
                self.createLocationNotification(presentingViewController: RootController.sharedController())
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                SAGEState.setLocationNotification(false)
            }))
            dispatch_async(dispatch_get_main_queue(),{
                RootController.sharedController().presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
    
    class func createLocationNotification(presentingViewController VC: UIViewController = RootController.sharedController()) {
        print("CREATING A LOCATION NOTIFICATION")
        if (UserAuthorization.userNotificationAllowed()) {
            
            guard let school = SAGEState.currentSchool(), location = school.location else {
                let errorAlert = UIAlertController(title: "Uh Oh.", message: "We encountered an error while creating your location notification. (Error Code UN1)", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                errorAlert.addAction(cancelAction)
                VC.presentViewController(errorAlert, animated: true, completion: nil)
                return
            }
            
            let name = school.name!.stringByReplacingOccurrencesOfString(" elementary school", withString: "", options: .CaseInsensitiveSearch, range: nil)
            let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            
            let entryRegion = CLCircularRegion(center: center, radius: 50, identifier: NotificationConstants.locationEntryRegionID)
            entryRegion.notifyOnEntry = true
            entryRegion.notifyOnExit = false
            
            let exitRegion = CLCircularRegion(center: center, radius: school.radius, identifier: NotificationConstants.locationExitRegionID)
            exitRegion.notifyOnEntry = false
            exitRegion.notifyOnExit = true
            
            let entrytitle = "Hi, \(SAGEState.currentUser()!.firstName!)!"
            let entrySubtitle = "Looks like you're close to \(name)."
            let entryBody = "Don't forget to begin your session \u{23F3}"
            
            if #available(iOS 10.0, *) {
                
                let entryContent = UNMutableNotificationContent()
                entryContent.title = entrytitle
                entryContent.subtitle = entrySubtitle
                entryContent.body = entryBody
                entryContent.sound = UNNotificationSound.defaultSound()
                entryContent.userInfo = [UIApplicationLaunchOptionsLocalNotificationKey: NotificationConstants.locationEntryNotificationID]
//                entryContent.categoryIdentifier = NotificationConstants.locationCategoryID
                
                let exitContent = UNMutableNotificationContent()
                exitContent.title = "Hi again, \(SAGEState.currentUser()!.firstName!)!"
                exitContent.subtitle = "Looks like you're leaving \(name)."
                exitContent.body = "Don't forget to finish your session."
                exitContent.sound = UNNotificationSound.defaultSound()
//                exitContent.categoryIdentifier = NotificationConstants.locationCategoryID
                
                let entryTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
                
//                let entryTrigger = UNLocationNotificationTrigger(region: entryRegion, repeats: true)
                let entryRequest = UNNotificationRequest(identifier: NotificationConstants.locationEntryNotificationID, content: entryContent, trigger: entryTrigger)
                
                // TODO: Not implemented
                let exitTrigger = UNLocationNotificationTrigger(region: exitRegion, repeats: true)
                let exitRequest = UNNotificationRequest(identifier: NotificationConstants.locationExitNotificationID, content: exitContent, trigger: exitTrigger)
                
                UNUserNotificationCenter.currentNotificationCenter().addNotificationRequest(entryRequest) {
                    (error) in
                    if error != nil {
                        let errorAlert = UIAlertController(title: "Uh Oh.", message: "We encountered an error while creating your location notification. (EC2)", preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                        errorAlert.addAction(cancelAction)
                        VC.presentViewController(errorAlert, animated: true, completion: nil)
                    }
                }
            } else {
                print("< iOS 10")
                
                var entryNotification = UILocalNotification()
//                entryNotification.region = entryRegion
                entryNotification.fireDate = NSDate(timeInterval: 10.0, sinceDate: NSDate())
                entryNotification.regionTriggersOnce = false
                entryNotification.alertTitle = entrytitle
                entryNotification.alertBody = "\(entrySubtitle) \(entryBody)"
                
                UIApplication.sharedApplication().scheduleLocalNotification(entryNotification)
            }
            
        }
    }
    
    class func removeAllPendingNotifications() {
        print("REMOVING ALL NOTIFICATIONS")
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().removeAllPendingNotificationRequests()
        } else {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
    class func removeDeliveredNotifications() {
        print("REMOVING DELIVERED NOTIFICATIONS")
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().removeAllDeliveredNotifications()
        }
    }
    
    class func debug() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().getNotificationCategoriesWithCompletionHandler() {
                (categories) in
                print("Set notification categories: \(categories.isEmpty ? "none" : "")", newLine: true)
                for category in categories {
                    Swift.print("\t\(category)")
                }
                Swift.print()
            }
            
            UNUserNotificationCenter.currentNotificationCenter().getPendingNotificationRequestsWithCompletionHandler() {
                (notifications) in
                print("Pending notifications: \(notifications.isEmpty ? "none" : "")", newLine: true)
                for notification in notifications {
                    Swift.print("\t\(notification.description)")
                }
                Swift.print()
            }
            
            UNUserNotificationCenter.currentNotificationCenter().getDeliveredNotificationsWithCompletionHandler() {
                (notifications) in
                print("Delivered notifications: \(notifications.isEmpty ? "none" : "")", newLine: true)
                for notification in notifications {
                    Swift.print("\t\(notification.request.identifier)")
                }
                Swift.print()
            }
            
        }
    }
    
    class func print(msg: String, newLine: Bool = false) {
        Swift.print("\(newLine ? "\n" : "")[\(self)] \(msg)")
    }
    
}
