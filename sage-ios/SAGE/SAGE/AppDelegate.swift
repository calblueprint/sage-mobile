//
//  AppDelegate.swift
//  SAGE
//
//  Created by Andrew Millman on 9/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
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

        // Push notifications
        let userNotificationTypes: UIUserNotificationType = [.Alert , .Badge , .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)

        //Handle push notifications
        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {

        }

        return true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //(self.window?.rootViewController as! RootController).pushCorrectViewController()
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
        PushNotificationOperations.registerForNotifications(tokenString, completion: { () -> Void in
            }) { (message) -> Void in
                print(message)
        }
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let objectString = userInfo[PushNotificationConstants.kObject] as! String
        let notificationType = userInfo[PushNotificationConstants.kType] as! Int

        switch notificationType {
        case PushNotificationConstants.kAnnouncementType:
            let announcementJSON = objectString.convertToDictionary()![PushNotificationConstants.kAnnouncement] as! [String: AnyObject]
            let announcement = Announcement(properties: announcementJSON)
            RootController.sharedController().handleNewAnnouncement(announcement, applicationState: application.applicationState)
        case PushNotificationConstants.kCheckInRequestType:
            let checkInRequestJSON = objectString.convertToDictionary()![PushNotificationConstants.kCheckInRequest] as! [String: AnyObject]
            let checkInRequest = Checkin(propertyDictionary: checkInRequestJSON)

            // App is already in foreground
            if (application.applicationState == .Active) {
                //RootController.sharedController().displayAnnouncement(announcement)
                return;
            }
            // App is transitioning from background to foreground
            //RootController.sharedController().displayAnnouncement(announcement)
        case PushNotificationConstants.kSignUpRequestType:
            let signUpRequestJSON = objectString.convertToDictionary()![PushNotificationConstants.kAnnouncement] as! [String: AnyObject]
            let signUpRequest = User(propertyDictionary: signUpRequestJSON)

            // App is already in foreground
            if (application.applicationState == .Active) {
                //RootController.sharedController().displayAnnouncement(announcement)
                return;
            }
            // App is transitioning from background to foreground
            //RootController.sharedController().displayAnnouncement(announcement)
        default:
            break
        }

    }
}

