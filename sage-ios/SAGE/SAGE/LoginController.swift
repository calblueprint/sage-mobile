//
//  LoginController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    override func loadView() {
        self.view = LoginView()
        (self.view as! LoginView).loginEmailField?.delegate = self
        (self.view as! LoginView).loginPasswordField?.delegate = self
        (self.view as! LoginView).signUpLink?.addTarget(self, action: "signUpLinkTapped", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func signUpLinkTapped() {
        let signUpController = SignUpController()
        signUpController.view.alpha = 0.0
        
        UIView.animateWithDuration(UIView.animationTime/2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                // initial animation
                let currentY = (self.view as! LoginView).containerView!.frame.origin.y
                (self.view as! LoginView).containerView!.setY(currentY + 5)
                self.view.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.displayViewController(signUpController)
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let loginView = (self.view as! LoginView)
        if let email = loginView.loginEmailField!.text {
            if let password = loginView.loginPasswordField!.text {
                LoginHelper.isValidLogin(email, password: password, completion: {
                    (valid: Bool) -> Void in
                    if (valid) {
                        self.pushRootTabBarController()
                    } else {
                        // indicate bad login
                    }
                })
            }
        }
        return true
    }
    
    func displayViewController(vc: UIViewController) {
        self.presentViewController(vc, animated: false, completion: nil)
    }
    
    func pushRootTabBarController() {
        LoginHelper.setUserSingleton()
        let rootTabBarController = RootTabBarController()
        self.displayViewController(rootTabBarController)
    }
    
}
