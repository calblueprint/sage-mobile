//
//  LoginController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    override func loadView() {
        self.view = LoginView()
        (self.view as! LoginView).loginEmailField.delegate = self
        (self.view as! LoginView).loginPasswordField.delegate = self
        (self.view as! LoginView).signUpLink.addTarget(self, action: "signUpLinkTapped", forControlEvents: .TouchUpInside)
        (self.view as! LoginView).loginButton.addTarget(self, action: "attemptLogin", forControlEvents: .TouchUpInside)
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
    
    
    //
    // MARK: - Login validation and logic methods
    //
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = (self.view as! LoginView).currentErrorMessage
        let errorView = super.showError(message, size: size, currentError: error)
        (self.view as! LoginView).currentErrorMessage = errorView
    }
    func attemptLogin() {
        let loginView = (self.view as! LoginView)
        if let email = loginView.loginEmailField.text {
            if let password = loginView.loginPasswordField.text {
                LoginHelper.isValidLogin(email, password: password, completion: {
                    (valid: Bool) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if (valid) {
                            if let verified = User.currentUser?.verified {
                                if verified {
                                    self.pushRootTabBarController()
                                } else {
                                    let unverifiedController = UnverifiedViewController()
                                    self.presentViewController(unverifiedController, animated: true, completion: nil)
                                }
                            } else {
                                let unverifiedController = UnverifiedViewController()
                                self.presentViewController(unverifiedController, animated: true, completion: nil)
                            }
                        } else {
                            // indicate bad login
                            self.showErrorAndSetMessage("Invalid login - try again!", size: 64)
                        }
                    })
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
