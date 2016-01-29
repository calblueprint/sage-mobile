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
        sageLabel.text = "If you want to be happy, be."
        sageLabel.textAlignment = .Center
        sageLabel.textColor = UIColor.whiteColor()
        sageLabel.font = UIFont.getDefaultFont(20)
        self.view.addSubview(sageLabel)
        
        self.pushCorrectViewController()
    }
    
    func pushCorrectViewController() {
        if LoginOperations.userIsLoggedIn() {
            LoginOperations.getState({ (user, currentSemester, userSemester) -> Void in
                KeychainWrapper.setObject(user, forKey: KeychainConstants.kUser)
                if !(currentSemester == nil) {
                    KeychainWrapper.setObject(currentSemester!, forKey: KeychainConstants.kCurrentSemester)
                }
                if !(userSemester == nil) {
                    KeychainWrapper.setObject(userSemester!, forKey: KeychainConstants.kUserSemester)
                }
                self.pushRootTabBarController()
                
                }) { (errorMessage) -> Void in
                    // error
            }
        } else {
            self.pushLoginViewController()
        }
    }
    
    // a function that will fill in values and present the login view controller
    func pushLoginViewController() {
        if self.loginController != nil {
            self.loginController?.view.alpha = 1.0
            self.view.bringSubviewToFront(self.loginController!.view)
        } else {
            let loginController = LoginController()
            self.loginController = loginController
            self.addChildViewController(loginController)
            self.view.addSubview(loginController.view)
        }
    }
    
    func pushUnverifiedViewController() {
        if self.unverifiedController != nil {
            self.view.bringSubviewToFront(self.unverifiedController!.view)
        } else {
            let unverifiedController = UnverifiedViewController()
            self.unverifiedController = unverifiedController
            self.addChildViewController(unverifiedController)
            self.view.addSubview(unverifiedController.view)
        }
    }
    
    func pushRootTabBarController() {
        if self.rootTabBarController != nil {
            self.view.bringSubviewToFront(self.rootTabBarController!.view)
        } else {
            let rootTabBarController = RootTabBarController()
            self.rootTabBarController = rootTabBarController
            self.addChildViewController(rootTabBarController)
            self.view.addSubview(rootTabBarController.view)
        }
    }
}
