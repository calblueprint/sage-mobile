//
//  LoginController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginController: SGViewController {
    
    var loginView = LoginView()

    override func loadView() {
        self.view = self.loginView
        self.loginView.loginEmailField.delegate = self
        self.loginView.loginPasswordField.delegate = self
        self.loginView.signUpLink.addTarget(self, action: #selector(LoginController.signUpLinkTapped), forControlEvents: .TouchUpInside)
        self.loginView.loginButton.addTarget(self, action: #selector(LoginController.attemptLogin), forControlEvents: .TouchUpInside)
        self.loginView.forgotPasswordLink.addTarget(self, action: #selector(LoginController.showResetPasswordScreen), forControlEvents: .TouchUpInside)
        self.loginView.backToLoginLink.addTarget(self, action: #selector(LoginController.backToLogin), forControlEvents: .TouchUpInside)
        self.loginView.forgotPasswordButton.addTarget(self, action: #selector(LoginController.resetPassword), forControlEvents: .TouchUpInside)
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
        let rootTabBarController = RootTabBarController()
        self.presentViewController(rootTabBarController, animated: false, completion: nil)
    }

    func pushUnverifiedViewController() {
        let unverifiedController = UnverifiedViewController()
        self.presentViewController(unverifiedController, animated: true, completion: nil)
    }
    
    //
    // MARK: - Login validation and logic methods
    //
    
    func showErrorAndSetMessage(message: String) {
        let error = self.loginView.currentErrorMessage
        let errorView = super.showError(message, currentError: error, alpha: 0.4, centered: false)
        self.loginView.currentErrorMessage = errorView
    }
    
    func resetPassword() {
        if self.loginView.loginEmailField.text == "" {
            self.showErrorAndSetMessage("Please enter an email.")
        } else {
            LoginOperations.sendPasswordResetRequest(self.loginView.loginEmailField.text!, completion: { () -> Void in
                    self.showErrorAndSetMessage("Password reset - check your email!")
                }, failure: { (message) -> Void in
                    self.showErrorAndSetMessage(message)
            })
        }
    }
    
    func backToLogin() {
        UIView.animateWithDuration(UIConstants.normalAnimationTime, delay: 0, usingSpringWithDamping: UIConstants.defaultSpringDampening, initialSpringVelocity: UIConstants.defaultSpringVelocity, options: .CurveEaseInOut, animations: { () -> Void in
            self.loginView.forgotPasswordButton.frame = self.loginView.loginButton.frame
            self.loginView.backToLoginLink.setY(CGRectGetMaxY(self.loginView.signUpLink.frame) + 5)
            self.loginView.sageLabel.alpha = 1
            self.loginView.forgotPasswordLabel.alpha = 0

            }) { (result) -> Void in
                UIView.animateWithDuration(UIView.animationTime, animations: { () -> Void in
                    // make some things appear
                    self.loginView.loginButton.alpha = 1
                    
                    self.loginView.signUpLink.alpha = 1
                    
                    self.loginView.forgotPasswordLink.alpha = 1
                    
                    self.loginView.loginPasswordField.alpha = 1
                    
                    self.loginView.secondDivider.alpha = 1
                    
                    
                    // make other things disappear
                    self.loginView.backToLoginLink.alpha = 0
                    
                    self.loginView.forgotPasswordButton.alpha = 0
                    
                })
        }

    }
    
    func showResetPasswordScreen() {

        UIView.animateWithDuration(UIView.animationTime, animations: { () -> Void in
            // make some things disappear
            self.loginView.loginButton.alpha = 0
            
            self.loginView.signUpLink.alpha = 0
            
            self.loginView.forgotPasswordLink.alpha = 0
            
            self.loginView.loginPasswordField.alpha = 0
            
            self.loginView.secondDivider.alpha = 0
            
            self.loginView.sageLabel.alpha = 0
            
            // make other things appear
            self.loginView.backToLoginLink.alpha = 1
            
            self.loginView.forgotPasswordButton.alpha = 1
            
            self.loginView.forgotPasswordLabel.alpha = 1
            
            }) { (result) -> Void in
                UIView.animateWithDuration(UIConstants.normalAnimationTime, delay: 0, usingSpringWithDamping: UIConstants.defaultSpringDampening, initialSpringVelocity: UIConstants.defaultSpringVelocity, options: .CurveEaseInOut, animations: { () -> Void in
                    self.loginView.forgotPasswordButton.setY(CGRectGetMaxY(self.loginView.loginEmailField.frame) + 10)
                    self.loginView.backToLoginLink.setY(CGRectGetMaxY(self.loginView.forgotPasswordButton.frame) + 10)
                    }) { (complete) -> Void in
                    }
        }
    }

    func attemptLogin() {
        if let email = self.loginView.loginEmailField.text {
            if let password = self.loginView.loginPasswordField.text {
                self.loginView.loginButton.startLoading()
                LoginOperations.loginWith(email, password: password, completion: {
                    (valid: Bool) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if (valid) {
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
                                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                    self.presentViewController(alertController, animated: true, completion: nil)
                                    LoginOperations.deleteUserKeychainData()
                                    self.presentViewController(RootController(), animated: true, completion: nil)
                            }
                        } else {
                            self.loginView.loginButton.stopLoading()
                            self.showErrorAndSetMessage("Invalid login - try again!")
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
