//
//  LoginView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.

import UIKit

class LoginView: UIView {
    
    var loginEmailField: UITextField = UITextField()
    var loginPasswordField: UITextField = UITextField()
    var signUpLink: UIButton = UIButton()
    var sageLabel: UILabel = UILabel()
    var containerView: UIView = UIView()
    var firstDivider: UIView = UIView()
    var secondDivider: UIView = UIView()
    var loginButton: UIButton = UIButton()
    var loginButtonText: UILabel = UILabel()
    var currentErrorMessage: ErrorView?
    
    var movedUp: Bool = false
    
    required override init(frame: CGRect) {
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        let newFrame = CGRectMake(0, 0, screenWidth, screenHeight)
        super.init(frame: newFrame)
        self.setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpViews()
    }
    
    //
    // MARK: - View setup methods
    //
    
    func setUpViews() {
        self.setUpBackground()
        self.setUpGestureRecognizer()
        self.setUpKeyboardNotifications()
        self.setUpLoginItems()
    }
    
    func setUpLoginItems() {
        self.addSubview(self.containerView)
        
        self.sageLabel.text = "SAGE"
        self.sageLabel.textColor = UIColor.whiteColor()
        self.sageLabel.font = UIFont.getTitleFont(64)
        
        self.containerView.addSubview(self.sageLabel)
        
        self.loginEmailField.textColor = UIColor.whiteColor()
        self.loginEmailField.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.loginEmailField.returnKeyType = .Next
        self.containerView.addSubview(self.loginEmailField)
        
        self.firstDivider.backgroundColor = UIColor.whiteColor()
        self.containerView.addSubview(self.firstDivider)
        
        self.loginPasswordField.textColor = UIColor.whiteColor()
        self.loginPasswordField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.loginPasswordField.secureTextEntry = true;
        self.loginPasswordField.returnKeyType = .Done
        self.containerView.addSubview(self.loginPasswordField)
        
        self.secondDivider.backgroundColor = UIColor.whiteColor()
        self.containerView.addSubview(self.secondDivider)
        
        let signUpString = "Don't have an account? Sign up here."
        let range = (signUpString as NSString).rangeOfString("here")
        let attributedString = NSMutableAttributedString(string: signUpString)
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(int: 1), range: range)
        self.signUpLink.setAttributedTitle(attributedString, forState: .Normal)
        self.signUpLink.titleLabel!.textAlignment = .Center
        self.signUpLink.titleLabel!.font = UIFont.metaFont
        self.signUpLink.titleLabel!.textColor = UIColor.whiteColor()
        self.containerView.addSubview(self.signUpLink)
        
        self.loginButton.backgroundColor = UIColor.whiteColor()
        self.loginButton.alpha = 0.45
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.clipsToBounds = true
        self.containerView.addSubview(self.loginButton)
        
        self.loginButtonText.textColor = UIColor.whiteColor()
        self.loginButtonText.text = "Log in"
        self.loginButtonText.textAlignment = NSTextAlignment.Center
        self.containerView.addSubview(self.loginButtonText)
        
    }
   
    func setUpBackground() {
        let frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        let image = UIImage.init(named: UIConstants.blurredBerkeleyBackground)
        let imageView = UIImageView.init(frame: frame)
        imageView.image = image
        self.addSubview(imageView)
    }
    
    
    override func layoutSubviews() {
        
        self.containerView.centerHorizontally()
        self.containerView.centerVertically()
        self.containerView.setHeight(self.frame.height * 0.6)
        self.containerView.setWidth(self.frame.width - 2 * UIConstants.sideMargin)
        self.containerView.setX(UIConstants.sideMargin)
        self.containerView.setY(self.frame.height * 0.2)
        
        self.sageLabel.setX(0)
        self.sageLabel.setY(0)
        self.sageLabel.setWidth(self.containerView.frame.width)
        self.sageLabel.setHeight(self.containerView.frame.height * 0.4)
        self.sageLabel.textAlignment = .Center
        
        let dividerMargin: CGFloat = 30
        let textOffset: CGFloat = 40
        let textFieldHeight: CGFloat = 40
        
        self.loginEmailField.setX(textOffset)
        self.loginEmailField.setY(self.containerView.frame.height * 0.35)
        self.loginEmailField.setWidth(self.containerView.frame.width - 2 * textOffset)
        self.loginEmailField.setHeight(textFieldHeight)
        
        self.firstDivider.setX(dividerMargin)
        self.firstDivider.setY(self.containerView.frame.height * 0.35 + textFieldHeight)
        self.firstDivider.setWidth(self.containerView.frame.width - 2 * dividerMargin)
        self.firstDivider.setHeight(UIConstants.dividerHeight())
        
        self.loginPasswordField.setX(textOffset)
        self.loginPasswordField.setY(self.containerView.frame.height * 0.48)
        self.loginPasswordField.setWidth(self.containerView.frame.width - 2 * textOffset)
        self.loginPasswordField.setHeight(textFieldHeight)
        
        self.secondDivider.setX(dividerMargin)
        self.secondDivider.setY(containerView.frame.height * 0.48 + textFieldHeight)
        self.secondDivider.setWidth(self.containerView.frame.width - 2 * dividerMargin)
        self.secondDivider.setHeight(UIConstants.dividerHeight())
        
        self.loginButton.setX(dividerMargin)
        self.loginButton.setWidth(self.containerView.frame.width - 2 * dividerMargin)
        self.loginButton.setHeight(40)
        self.loginButton.setY(self.containerView.frame.height * 0.48 + 65)
        
        self.loginButtonText.frame = self.loginButton.frame
        
        self.signUpLink.setX(0)
        self.signUpLink.setY(CGRectGetMaxY(self.loginButton.frame) + 20)
        self.signUpLink.setWidth(self.containerView.frame.width)
        self.signUpLink.setHeight(20)
    }
    
    //
    // MARK: - Gesture recognizer methods
    //
    
    func setUpGestureRecognizer() {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: "screenTapped")
        self.addGestureRecognizer(recognizer)
        self.userInteractionEnabled = true
    }
    
    func screenTapped() {
        self.containerView.endEditing(true)
        self.endEditing(true)
    }
    
    //
    // MARK: - Keyboard-related methods (to move up elements when the keyboard appears)
    //
    
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
            
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
                self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, (self.containerView.frame.origin.y - keyboardHeight/4), self.containerView.bounds.width, self.containerView.bounds.height)
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
            
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
                self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, (self.containerView.frame.origin.y + keyboardHeight/4), self.containerView.bounds.width, self.containerView.bounds.height)
                }, completion: nil)
            
            self.movedUp = false
        }
    }
    
}












