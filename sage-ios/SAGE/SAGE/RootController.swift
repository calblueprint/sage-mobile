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
    var initialSplashView = SplashView(frame: CGRect(), animated: false)
    var animatedSplashView = SplashView(frame: CGRect(), animated: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.initialSplashView)
        
        let sageFrame = CGRectMake(0, self.view.frame.height/20, self.view.frame.width, self.view.frame.height)
        let sageLabel = UILabel.init(frame: sageFrame)
        sageLabel.text = ""
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
                self.initialSplashView.removeFromSuperview()
                if (user.verified) {
                    self.pushRootTabBarController()
                } else {
                    self.pushUnverifiedViewController()
                }
                self.view.addSubview(self.animatedSplashView)
                self.performSelector("removeSplashView", withObject: nil, afterDelay: self.animatedSplashView.animationDuration)
                }) { (errorMessage) -> Void in
                    let alertController = UIAlertController(
                        title: "Failure",
                        message: errorMessage as String,
                        preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                        LoginOperations.deleteUserKeychainData()
                        self.pushLoginViewController()
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            self.initialSplashView.removeFromSuperview()
            self.pushLoginViewController()
            self.view.addSubview(self.animatedSplashView)
            self.performSelector("removeSplashView", withObject: nil, afterDelay: self.animatedSplashView.animationDuration)
        }
    }
    
    func removeSplashView() {
        self.animatedSplashView.removeFromSuperview()
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
