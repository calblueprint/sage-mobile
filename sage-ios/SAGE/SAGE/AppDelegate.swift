//
//  AppDelegate.swift
//  SAGE
//
//  Created by Andrew Millman on 9/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import GoogleMaps
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GMSServices.provideAPIKey(APIKeys.googleMaps)
        GMSPlacesClient.provideAPIKey(APIKeys.googleMaps)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = RootController.sharedController()
        window?.makeKeyAndVisible()
        
        // Navigation bar appearance
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UINavigationBar.appearance().barTintColor = UIColor.mainColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().translucent = false
        
        // Handle push notifications
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            self.handleNotification(userInfo, applicationState: application.applicationState, launching: true)
        }
        
        // Handle local notifications
        if let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] {
            NSLog("Launched by local notification: \(notification)")
            if #available(iOS 10.0, *) {
                // handled by delegate
            } else {
                RootController.sharedController().showCheckinView()
            }
        }
        
        // Handle launch from shortcut
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
                self.handleShortcut(shortcutItem)
                return false
            }
        }
        
        // Get authorization for local notifications
        UserAuthorization.userNotificationInitialAuthorization()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().delegate = self
        }

        UserNotifications.removeDeliveredNotifications()
        self.resetIconBadgeNumber(application)
        return true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        UserNotifications.removeDeliveredNotifications()
        self.resetIconBadgeNumber(application)
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""

        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        PushNotificationOperations.registerForNotifications(tokenString, completion: { () -> Void in })
        { (message) -> Void in
            //print(message)
        }
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //print("Failed to register:", error)
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if SAGEState.currentUser() != nil {
            self.handleNotification(userInfo, applicationState: application.applicationState, launching: false)
        }
    }
    
    //
    // MARK: - Shortcut Delegate
    //
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        completionHandler(self.handleShortcut(shortcutItem))
    }
    
    @available(iOS 9.0, *)
    private func handleShortcut(item: UIApplicationShortcutItem) -> Bool {
        print("Shortcut used: \(item)")
        RootController.sharedController().showCheckinView()
        return true
    }
    
    //
    // MARK: - UILocalNotification Delegate (Depreciated in iOS 10)
    //
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        RootController.sharedController().showCheckinView()
    }
    
    //
    // MARK: - UNUserNotification Delegate (iOS 10 only)
    //
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {

        if (response.actionIdentifier == UNNotificationDefaultActionIdentifier) {
            RootController.sharedController().showCheckinView()
        } else if (response.actionIdentifier == NotificationConstants.beginSessionActionID) {
            print("UN response recieved.")
        }
        
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        print("Recieved notification in foreground: \(notification)")
        UserNotifications.removeDeliveredNotifications()
        completionHandler([.Alert, .Sound])
    }
    
    //
    // MARK: - Private Functions
    //
    private func resetIconBadgeNumber(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    private func handleNotification(notification: [NSObject: AnyObject], applicationState: UIApplicationState, launching: Bool) {
        let objectString = notification[PushNotificationConstants.kObject] as! String
        let notificationType = notification[PushNotificationConstants.kType] as! Int

        switch notificationType {
        case PushNotificationConstants.kAnnouncementType:
            let announcementJSON = objectString.convertToDictionary()![PushNotificationConstants.kAnnouncement] as! [String: AnyObject]
            let announcement = Announcement(propertyDictionary: announcementJSON)
            RootController.sharedController().handleNewAnnouncement(announcement, applicationState: applicationState, launching: launching)
        case PushNotificationConstants.kCheckInRequestType:
            let checkInRequestJSON = objectString.convertToDictionary()![PushNotificationConstants.kCheckInRequest] as! [String: AnyObject]
            let checkInRequest = Checkin(propertyDictionary: checkInRequestJSON)
            RootController.sharedController().handleNewCheckInRequest(checkInRequest, applicationState: applicationState, launching: launching)
        case PushNotificationConstants.kSignUpRequestType:
            let signUpRequestJSON = objectString.convertToDictionary()![PushNotificationConstants.kSignUpRequest] as! [String: AnyObject]
            let signUpRequest = User(propertyDictionary: signUpRequestJSON)
            RootController.sharedController().handleNewSignUpRequest(signUpRequest, applicationState: applicationState, launching: launching)

        default:
            break
        }
    }
}

