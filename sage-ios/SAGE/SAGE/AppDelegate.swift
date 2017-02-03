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

        //Handle push notifications
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            self.handleNotification(userInfo, applicationState: application.applicationState, launching: true)
        }
        
        //Handle local notifications
//        if let userInfo = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? [String: AnyObject] {
//            print("Launched by local notification")
//            print(userInfo)
//        }
        
        // Get authorization for local notifications
        UserAuthorization.userNotificationInitialAuthorization()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().delegate = self

//            UserNotifications.setup()
            UserNotifications.launch()
        } else {
            // Fallback on earlier versions
        }

        self.resetIconBadgeNumber(application)
        return true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        self.resetIconBadgeNumber(application)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NotificationConstants.appStateBecameActive, object: nil))
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
    // MARK: - UILocalNotification Delegate (Depreciated in iOS 10)
    //
    //TODO
    
    //
    // MARK: - UNUserNotification Delegate (iOS 10 only)
    //
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        if (response.actionIdentifier == NotificationConstants.beginSessionActionID) {
            print("UN begin response recieved.")
        }
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        print("Recieved notification in foreground: \(notification)")
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

