//
//  LoginController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    var currentErrorMessage: ErrorView?
    
    override func loadView() {
        self.view = LoginView()
        (self.view as! LoginView).loginEmailField.delegate = self
        (self.view as! LoginView).loginPasswordField.delegate = self
        (self.view as! LoginView).signUpLink.addTarget(self, action: "signUpLinkTapped", forControlEvents: .TouchUpInside)
    }
    
    //
    // MARK: - Methods to control events on the view
    //
    
    func signUpLinkTapped() {
        let signUpController = SignUpController()
        signUpController.view.alpha = 0.0
        
        UIView.animateWithDuration(UIView.animationTime/2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                // initial animation
                let currentY = (self.view as! LoginView).containerView.frame.origin.y
                (self.view as! LoginView).containerView.setY(currentY + 5)
                self.view.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.presentViewController(signUpController, animated: false, completion: nil)
        })
    }
    
    //
    // MARK: - Methods to handle navigation
    //
    
    func pushRootTabBarController() {
        LoginHelper.setUserSingleton()
        let rootTabBarController = RootTabBarController()
        self.presentViewController(rootTabBarController, animated: false, completion: nil)
    }
    
    func showError(message: String) {
        if let current = self.currentErrorMessage {
            current.removeFromSuperview()
        }
        
        let errorView = ErrorView(height: 64.0, messageString: message)
        self.view.addSubview(errorView)
        self.view.bringSubviewToFront(errorView)
        errorView.setX(0)
        errorView.setY(0)
        self.currentErrorMessage = errorView
        
        UIView.animateWithDuration(1, delay: 3, options: .CurveLinear, animations: { () -> Void in
            errorView.alpha = 0.0
            }, completion: nil)
    }
    
    func attemptLogin() {
        let loginView = (self.view as! LoginView)
        if let email = loginView.loginEmailField.text {
            if let password = loginView.loginPasswordField.text {
                LoginHelper.isValidLogin(email, password: password, completion: {
                    (valid: Bool) -> Void in
                    if (valid) {
                        self.pushRootTabBarController()
                    } else {
                        // indicate bad login
                        self.showError("Invalid login - try again!")
                    }
                })
            }
        }
    }
    
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let loginView = (self.view as! LoginView)
        if textField == loginView.loginEmailField {
            loginView.loginPasswordField.becomeFirstResponder()
        } else if textField == loginView.loginPasswordField {
            self.attemptLogin()
        }
        return true
    }
}
