//
//  RootController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class RootController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        if LoginHelper.userIsLoggedIn() {
            if LoginHelper.userIsVerified() {
                self.pushRootTabBarController()
            } else {
                self.pushUnverifiedViewController()
            }
        } else {
            self.pushLoginViewController()
        }
    }
    
    func setUpView() {
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
        sageLabel.textAlignment = NSTextAlignment.Center
        sageLabel.textColor = UIColor.whiteColor()
        sageLabel.font = UIFont.systemFontOfSize(20)
        self.view.addSubview(sageLabel)
    }
    
    // a function that will fill in values and present the login view controller
    func pushLoginViewController() {
        let loginController = LoginController()
        self.showViewController(loginController, sender: self)
    }
    
    func pushUnverifiedViewController() {
        let unverifiedController = UnverifiedViewController()
        self.showViewController(unverifiedController, sender: self)
    }
    
    func pushRootTabBarController() {
        LoginHelper.setUserSingleton()
        let rootTabBarController = RootTabBarController()
        self.presentViewController(rootTabBarController, animated: false, completion: nil)
        self.showViewController(rootTabBarController, sender: self)
    }
}
