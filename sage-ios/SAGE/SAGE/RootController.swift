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
        
        self.pushCorrectViewController()
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
    }
    
    //
    // MARK: - Private Methods
    //
    private func clearViews() {
        self.loginController?.view.alpha = 0
        self.rootTabBarController?.view.alpha = 0
        self.unverifiedController?.view.alpha = 0
    }

    //
    // MARK: - Push Notification Handling
    //
    func displayAnnouncement(announcement: Announcement) {
        self.rootTabBarController?.displayAnnouncement(announcement)
    }
}
