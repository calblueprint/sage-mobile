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

        //Handle push notifications
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            self.handleNotification(userInfo, applicationState: application.applicationState, launching: true)
        }

        return true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        // Push notifications
        let userNotificationTypes: UIUserNotificationType = [.Alert , .Badge , .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
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
            print(message)
        }
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if SAGEState.currentUser() != nil {
            self.handleNotification(userInfo, applicationState: application.applicationState, launching: false)
        }
    }

    //
    // MARK: - Private Functions
    //
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
            let signUpRequestJSON = objectString.convertToDictionary()![PushNotificationConstants.kAnnouncement] as! [String: AnyObject]
            let signUpRequest = User(propertyDictionary: signUpRequestJSON)
            RootController.sharedController().handleNewSignUpRequest(signUpRequest, applicationState: applicationState, launching: launching)

        default:
            break
        }
    }
}

