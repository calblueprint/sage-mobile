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
        self.view = LoginView.init()
        (self.view as! LoginView).loginEmailField?.delegate = self
        (self.view as! LoginView).loginPasswordField?.delegate = self
        (self.view as! LoginView).signUpLink?.addTarget(self, action: "signUpLinkTapped", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func signUpLinkTapped() {
        // redirect to sign in here
    }
    
    func proceedToMainApplication() {
        // show root tab bar controller
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
        self.showViewController(vc, sender: self)
    }
    
    func pushRootTabBarController() {
        LoginHelper.setUserSingleton()
        let rootTabBarController = RootTabBarController()
        self.displayViewController(rootTabBarController)
    }
    
}
