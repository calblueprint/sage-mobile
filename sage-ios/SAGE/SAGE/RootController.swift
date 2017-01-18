//
//  RootController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class RootController: UIViewController {
    
    var loginController: LoginController?
    var unverifiedController: UnverifiedViewController?
    var rootTabBarController: RootTabBarController?
    
    private var notifiedAnnouncementIds = Set<Int>()
    private var notifiedCheckinRequestIds = Set<Int>()
    private var notifiedSignupRequestIds = Set<Int>()

    private var notifiedAnnouncement: Announcement?
    private var notifiedCheckinRequest: Checkin?
    private var notifiedSignupRequest: User?

    private var notificationView = NotificationView()

    private struct SharedController {
        static var controller = RootController()
    }

    class func sharedController() -> RootController {
        return RootController.SharedController.controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let image = UIImage.init(named: UIConstants.blurredBerkeleyBackground)
        let imageView = UIImageView.init(frame: frame)
        imageView.image = image
        self.view.addSubview(imageView)
        
        let activityIndicatorFrame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let activityIndicator = UIActivityIndicatorView(frame: activityIndicatorFrame)
        activityIndicator.color = UIColor.whiteColor()
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        let sageFrame = CGRectMake(0, self.view.frame.height/20, self.view.frame.width, self.view.frame.height)
        let sageLabel = UILabel.init(frame: sageFrame)
        sageLabel.text = ""
        sageLabel.textAlignment = .Center
        sageLabel.textColor = UIColor.whiteColor()
        sageLabel.font = UIFont.getDefaultFont(20)
        self.view.addSubview(sageLabel)
        
        self.view.addSubview(self.notificationView)

        self.pushCorrectViewController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.notificationView.setX(0)
        self.notificationView.fillWidth()
    }

    //
    // MARK: - Public Methods
    //
    func pushCorrectViewController() {
        if SAGEState.currentUser() != nil {
            LoginOperations.getState({ (user, currentSemester, userSemester) -> Void in
                if (user.verified) {
                    self.pushRootTabBarController()
                } else {
                    self.pushUnverifiedViewController()
                }
                }) { (errorMessage) -> Void in
                    let alertController = UIAlertController(
                        title: "Failure",
                        message: errorMessage as String,
                        preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                        SAGEState.reset()
                        self.pushLoginViewController()
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)

            }
        } else {
            self.pushLoginViewController()
        }
    }
    
    // a function that will fill in values and present the login view controller
    func pushLoginViewController() {
        self.clearViews()
        if self.loginController != nil {
            self.loginController?.view.alpha = 1.0
            self.loginController?.loginView.resetFields()
            self.view.bringSubviewToFront(self.loginController!.view)
        } else {
            let loginController = LoginController()
            self.loginController = loginController
            self.addChildViewController(loginController)
            self.view.addSubview(loginController.view)
        }
    }
    
    func pushUnverifiedViewController() {
        self.clearViews()
        if self.unverifiedController != nil {
            self.unverifiedController?.view.alpha = 1
            self.view.bringSubviewToFront(self.unverifiedController!.view)
        } else {
            let unverifiedController = UnverifiedViewController()
            self.unverifiedController = unverifiedController
            self.addChildViewController(unverifiedController)
            self.view.addSubview(unverifiedController.view)
        }
    }
    
    func pushRootTabBarController() {
        self.clearViews()
        if self.rootTabBarController != nil {
            self.rootTabBarController?.removeFromParentViewController()
            self.rootTabBarController?.view.removeFromSuperview()
        }
        let newRootTabBarController = RootTabBarController()
        self.rootTabBarController = newRootTabBarController
        self.addChildViewController(newRootTabBarController)
        self.view.addSubview(newRootTabBarController.view)

        // Go to notification view if notification is attached during launch
        self.handleNotificationFromLaunch()

        // Push notifications
        let userNotificationTypes: UIUserNotificationType = [.Alert , .Badge , .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    //
    // MARK: - Private Methods
    //
    private func clearViews() {
        self.loginController?.view.alpha = 0
        self.rootTabBarController?.view.alpha = 0
        self.unverifiedController?.view.alpha = 0
    }

    private func showNotificationView(title title: String, subtitle: String, image: UIImage?) {
        self.view.bringSubviewToFront(self.notificationView)
        self.notificationView.showNotification(title: title, subtitle: subtitle, image: image)
    }

    //
    // MARK: - Push Notification Handling
    //
    func handleNewAnnouncement(announcement: Announcement, applicationState: UIApplicationState, launching: Bool) {
        // Check for duplicate notifications because iOS 9 sucks
        if !self.notifiedAnnouncementIds.contains(announcement.id!) {
            self.notifiedAnnouncementIds.insert(announcement.id!)
            // App is already in foreground
            if (applicationState == .Active) {
                //if announcementController is active
                if self.rootTabBarController?.activeIndex() != .Announcement {
                    let profileImageView = ProfileImageView()
                    profileImageView.setImageWithUser(announcement.sender!)
                    self.showNotificationView(title: announcement.sender!.fullName(), subtitle: announcement.text!, image: profileImageView.image())
                }
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.addAnnouncementKey, object: announcement)
            } else {
                if launching {
                    // App is just launching, let self.handleNotificationFromLaunch get called
                    self.notifiedAnnouncement = announcement
                } else {
                    // App is transitioning from background to foreground
                    self.rootTabBarController?.setActiveIndex(.Announcement)
                    self.rootTabBarController?.displayAnnouncement(announcement, resetData: true)
                }
            }
        }
    }
    
    func handleNewCheckInRequest(checkinRequest: Checkin, applicationState: UIApplicationState, launching: Bool) {
        // Check for duplicate notifications because iOS 9 sucks
        if !self.notifiedCheckinRequestIds.contains(checkinRequest.id) {
            self.notifiedCheckinRequestIds.insert(checkinRequest.id)
            // App is already in foreground
            if (applicationState == .Active) {
                //if announcementController is active
                if self.rootTabBarController?.activeIndex() != .Special {
                    let profileImageView = ProfileImageView()
                    profileImageView.setImageWithUser(checkinRequest.user!)
                    self.showNotificationView(title: checkinRequest.user!.fullName(), subtitle: "New Checkin Request", image: profileImageView.image())
                }
                // TODO: add NSNotification for new checkin request
            } else {
                if launching {
                    // App is just launching, let self.handleNotificationFromLaunch get called
                    self.notifiedCheckinRequest = checkinRequest
                } else {
                    // App is transitioning from background to foreground
                    self.rootTabBarController?.setActiveIndex(.Special)
                    self.rootTabBarController?.displayCheckinRequestsView()
                }
            }
        }
    }
    
    func handleNewSignUpRequest(user: User, applicationState: UIApplicationState, launching: Bool) {
        // Check for duplicate notifications because iOS 9 sucks
        if !self.notifiedSignupRequestIds.contains(user.id) {
            self.notifiedSignupRequestIds.insert(user.id)
            // App is already in foreground
            if (applicationState == .Active) {
                //if announcementController is active
                if self.rootTabBarController?.activeIndex() != .Special {
                    let profileImageView = ProfileImageView()
                    profileImageView.setImageWithUser(user)
                    self.showNotificationView(title: user.fullName(), subtitle: "New Signup Request", image: profileImageView.image())
                }
                // TODO: add NSNotification for new signup request
            } else {
                if launching {
                    // App is just launching, let self.handleNotificationFromLaunch get called
                    self.notifiedSignupRequest = user
                } else {
                    // App is transitioning from background to foreground
                    self.rootTabBarController?.setActiveIndex(.Special)
                    self.rootTabBarController?.displaySignupRequestsView()
                }
            }
        }
    }

    private func handleNotificationFromLaunch() {
        if let announcement = self.notifiedAnnouncement {
            self.rootTabBarController?.setActiveIndex(.Announcement)
            self.rootTabBarController?.displayAnnouncement(announcement)
        } else if self.notifiedCheckinRequest != nil {
            self.rootTabBarController?.setActiveIndex(.Special)
            self.rootTabBarController?.displayCheckinRequestsView()
        } else if self.notifiedSignupRequest != nil {
            self.rootTabBarController?.setActiveIndex(.Special)
            self.rootTabBarController?.displaySignupRequestsView()
        }
    }
}
