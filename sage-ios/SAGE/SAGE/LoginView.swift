//
//  LoginView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.

import UIKit

class LoginView: UIView, UITextFieldDelegate {
    
    var loginUsernameField: UITextField?
    var loginPasswordField: UITextField?
    var signUpLink: UILabel?
    var containerView: UIView?
    
    var movedUp: Bool = false
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }
    
    func setUpView () {
        self.setUpBackground()
        self.setUpGestureRecognizer()
        self.setUpKeyboardNotifications()
        self.setUpLoginArea()
    }
    
    func screenTapped() {
        self.containerView?.endEditing(true)
        self.endEditing(true)
    }
   
    func setUpBackground() {
        let frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        let image = UIImage.init(named: UIConstants.blurredBerkeleyBackground)
        let imageView = UIImageView.init(frame: frame)
        imageView.image = image
        self.addSubview(imageView)
    }
    
    // dismisses the keyboard when the return key is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func setUpGestureRecognizer() {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: "screenTapped")
        self.addGestureRecognizer(recognizer)
        self.userInteractionEnabled = true
    }
    
    func setUpKeyboardNotifications() {
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (!self.movedUp) {
            let info:NSDictionary = notification.userInfo!
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            let keyboardHeight: CGFloat = keyboardSize.height
            
            let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as CGFloat
            
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.containerView!.frame = CGRectMake(self.containerView!.frame.origin.x, (self.containerView!.frame.origin.y - keyboardHeight/4), self.containerView!.bounds.width, self.containerView!.bounds.height)
                }, completion: nil)
            
            self.movedUp = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (self.movedUp) {
            let info: NSDictionary = notification.userInfo!
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            
            let keyboardHeight: CGFloat = keyboardSize.height
            
            let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as CGFloat
            
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.containerView!.frame = CGRectMake(self.containerView!.frame.origin.x, (self.containerView!.frame.origin.y + keyboardHeight/4), self.containerView!.bounds.width, self.containerView!.bounds.height)
                }, completion: nil)
            
            self.movedUp = false
        }
    }
    
    func setUpLoginArea() {
        
        let containerView = UIView()
        self.containerView = containerView
        containerView.centerHorizontally()
        containerView.centerVertically()
        containerView.setHeight(self.frame.height * 0.6)
        containerView.setWidth(self.frame.width - 2 * UIConstants.sideMargin)
        containerView.setX(UIConstants.sideMargin)
        containerView.setY(self.frame.height * 0.2)
        self.addSubview(containerView)
        
        let sageFrame = CGRectMake(0, 0, containerView.frame.width, containerView.frame.height * 0.4)
        let sageLabel = UILabel.init(frame: sageFrame)
        sageLabel.text = "SAGE"
        sageLabel.textAlignment = NSTextAlignment.Center
        sageLabel.textColor = UIColor.whiteColor()
        sageLabel.font = UIFont.getTitleFont(64)
        containerView.addSubview(sageLabel)
        
        let dividerMargin: CGFloat = 30
        let textOffset: CGFloat = 40
        
        let usernameFrame = CGRectMake(textOffset, containerView.frame.height * 0.35, containerView.frame.width - 2 * textOffset, 40)
        self.loginUsernameField = UITextField(frame: usernameFrame)
        self.loginUsernameField?.textColor = UIColor.whiteColor()
        self.loginUsernameField?.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.loginUsernameField?.centerHorizontally()
        self.alignBottomWithMargin(0)
        containerView.addSubview(self.loginUsernameField!)
        
        let firstDividerFrame = CGRectMake(dividerMargin, containerView.frame.height * 0.35 + 40, containerView.frame.width - 2 * dividerMargin, UIConstants.dividerHeight())
        let firstDivider = UIView(frame: firstDividerFrame)
        firstDivider.alignBottomWithMargin(0)
        firstDivider.backgroundColor = UIColor.whiteColor()
        containerView.addSubview(firstDivider)
        
        let passwordFrame = CGRectMake(textOffset, containerView.frame.height * 0.48, containerView.frame.width - 2 * textOffset, 40)
        self.loginPasswordField = UITextField(frame: passwordFrame)
        self.loginPasswordField?.textColor = UIColor.whiteColor()
        self.loginPasswordField?.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        containerView.addSubview(self.loginPasswordField!)
        
        let secondDividerFrame = CGRectMake(dividerMargin, containerView.frame.height * 0.48 + 40, containerView.frame.width - 2 * dividerMargin, UIConstants.dividerHeight())
        let secondDivider = UIView(frame: secondDividerFrame)
        secondDivider.alignBottomWithMargin(0)
        secondDivider.backgroundColor = UIColor.whiteColor()
        containerView.addSubview(secondDivider)
        
    }    
    
}

