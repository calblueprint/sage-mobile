//
//  SignUpEmailPasswordView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpEmailPasswordView: SignUpFormView {
    
    var emailInput: UITextField = UITextField()
    var passwordInput: UITextField = UITextField()
    var firstDivider: UIView = UIView()
    var secondDivider: UIView = UIView()
    
    override func setUpViews() {
        super.setUpViews()
        // add everything to the containerview
        self.containerView.addSubview(self.emailInput)
        self.containerView.addSubview(self.passwordInput)
        self.containerView.addSubview(self.firstDivider)
        self.containerView.addSubview(self.secondDivider)
        
        self.emailInput.textColor = UIColor.whiteColor()
        self.emailInput.returnKeyType = .Next
        self.passwordInput.textColor = UIColor.whiteColor()
        self.passwordInput.returnKeyType = .Next
        self.firstDivider.backgroundColor = UIColor.whiteColor()
        self.secondDivider.backgroundColor = UIColor.whiteColor()
        
        self.emailInput.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.passwordInput.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.passwordInput.secureTextEntry = true
        self.headerLabel.text = "Great!"
        self.subHeaderLabel.text = "What's your email and password?"
        
        // set icon and color
        let emailIcon = FAKIonIcons.emailIconWithSize(48)
        emailIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
        let emailImage = emailIcon.imageWithSize(CGSizeMake(48, 48))
        self.icon.image = emailImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let textOffset: CGFloat = 40
        let textFieldHeight: CGFloat = 40
        let dividerMargin: CGFloat = 30
        
        self.emailInput.setY(CGRectGetMaxY(self.icon.frame) + 40)
        self.emailInput.setX(textOffset + UIConstants.sideMargin)
        self.emailInput.setWidth(screenWidth - textOffset * 2 - 2 * UIConstants.sideMargin)
        self.emailInput.setHeight(textFieldHeight)
        
        self.firstDivider.setX(dividerMargin + UIConstants.sideMargin)
        self.firstDivider.setY(CGRectGetMaxY(self.emailInput.frame))
        self.firstDivider.setWidth(screenWidth - 2 * dividerMargin - 2 * UIConstants.sideMargin)
        self.firstDivider.setHeight(UIConstants.dividerHeight())
        
        self.passwordInput.setY(CGRectGetMaxY(self.emailInput.frame) + 10)
        self.passwordInput.setX(textOffset + UIConstants.sideMargin)
        self.passwordInput.setWidth(screenWidth - textOffset * 2 - 2 * UIConstants.sideMargin)
        self.passwordInput.setHeight(textFieldHeight)
        
        self.secondDivider.setX(dividerMargin + UIConstants.sideMargin)
        self.secondDivider.setY(CGRectGetMaxY(self.passwordInput.frame))
        self.secondDivider.setWidth(screenWidth - 2 * dividerMargin - 2 * UIConstants.sideMargin)
        self.secondDivider.setHeight(UIConstants.dividerHeight())
    }
}
