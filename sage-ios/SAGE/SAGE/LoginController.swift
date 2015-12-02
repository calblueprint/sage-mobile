//
//  LoginController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    var loginView = LoginView()

    override func loadView() {
        self.view = self.loginView
        self.loginView.loginEmailField.delegate = self
        self.loginView.loginPasswordField.delegate = self
        self.loginView.signUpLink.addTarget(self, action: "signUpLinkTapped", forControlEvents: .TouchUpInside)
        self.loginView.loginButton.addTarget(self, action: "attemptLogin", forControlEvents: .TouchUpInside)
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
    
    
    //
    // MARK: - Login validation and logic methods
    //
    
    func showErrorAndSetMessage(message: String) {
        let error = self.loginView.currentErrorMessage
        let errorView = super.showError(message, currentError: error)
        self.loginView.currentErrorMessage = errorView
    }

    func attemptLogin() {
        if let email = self.loginView.loginEmailField.text {
            if let password = self.loginView.loginPasswordField.text {
                self.loginView.loginButton.startLoading()
                LoginOperations.loginWith(email, password: password, completion: {
                    (valid: Bool) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if (valid) {
                            if let verified = LoginOperations.getUser()?.verified {
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
