//
//  SignUpPasswordView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpPasswordView: SignUpFormView {
    
    var password: UITextField = UITextField()
    var passwordConfirmation: UITextField = UITextField()
    var firstDivider: UIView = UIView()
    var secondDivider: UIView = UIView()
    
    override func setUpViews() {
        super.setUpViews()
        // add everything to the containerview
        self.containerView.addSubview(self.password)
        self.containerView.addSubview(self.passwordConfirmation)
        self.containerView.addSubview(self.firstDivider)
        self.containerView.addSubview(self.secondDivider)
        
        self.password.textColor = UIColor.whiteColor()
        self.password.returnKeyType = .Next
        self.password.autocorrectionType = .No
        
        self.passwordConfirmation.textColor = UIColor.whiteColor()
        self.passwordConfirmation.returnKeyType = .Next
        self.passwordConfirmation.autocorrectionType = .No
        
        self.firstDivider.backgroundColor = UIColor.whiteColor()
        self.secondDivider.backgroundColor = UIColor.whiteColor()
        
        self.password.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.password.secureTextEntry = true

        self.passwordConfirmation.attributedPlaceholder = NSAttributedString(string:"Confirmation", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.passwordConfirmation.secureTextEntry = true
        
        self.headerLabel.text = "Great!"
        self.subHeaderLabel.text = "What's your password?"
        
        // set icon and color
        let passwordIcon = FAKIonIcons.keyIconWithSize(48)
        passwordIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
        let passwordImage = passwordIcon.imageWithSize(CGSizeMake(48, 48))
        self.icon.image = passwordImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let textOffset: CGFloat = 40
        let textFieldHeight: CGFloat = 40
        let dividerMargin: CGFloat = 30
        
        self.password.setY(CGRectGetMaxY(self.icon.frame) + 40)
        self.password.setX(textOffset + UIConstants.sideMargin)
        self.password.setWidth(screenWidth - textOffset * 2 - 2 * UIConstants.sideMargin)
        self.password.setHeight(textFieldHeight)
        
        self.firstDivider.setX(dividerMargin + UIConstants.sideMargin)
        self.firstDivider.setY(CGRectGetMaxY(self.password.frame))
        self.firstDivider.setWidth(screenWidth - 2 * dividerMargin - 2 * UIConstants.sideMargin)
        self.firstDivider.setHeight(UIConstants.dividerHeight())
        
        self.passwordConfirmation.setY(CGRectGetMaxY(self.password.frame) + 10)
        self.passwordConfirmation.setX(textOffset + UIConstants.sideMargin)
        self.passwordConfirmation.setWidth(screenWidth - textOffset * 2 - 2 * UIConstants.sideMargin)
        self.passwordConfirmation.setHeight(textFieldHeight)
        
        self.secondDivider.setX(dividerMargin + UIConstants.sideMargin)
        self.secondDivider.setY(CGRectGetMaxY(self.passwordConfirmation.frame))
        self.secondDivider.setWidth(screenWidth - 2 * dividerMargin - 2 * UIConstants.sideMargin)
        self.secondDivider.setHeight(UIConstants.dividerHeight())
    }
}
