//
//  SignUpNameView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpNameView: SignUpFormView {
    
    var firstNameInput: UITextField = UITextField()
    var lastNameInput: UITextField = UITextField()
    var firstDivider: UIView = UIView()
    var secondDivider: UIView = UIView()
    
    override func setUpViews() {
        super.setUpViews()
        // add everything to the containerview
        self.containerView.addSubview(self.firstNameInput)
        self.containerView.addSubview(self.lastNameInput)
        self.containerView.addSubview(self.firstDivider)
        self.containerView.addSubview(self.secondDivider)
        
        self.firstNameInput.textColor = UIColor.whiteColor()
        self.firstNameInput.returnKeyType = .Next
        self.firstNameInput.autocorrectionType = .No

        self.lastNameInput.textColor = UIColor.whiteColor()
        self.lastNameInput.returnKeyType = .Next
        self.lastNameInput.autocorrectionType = .No

        self.firstDivider.backgroundColor = UIColor.whiteColor()
        self.secondDivider.backgroundColor = UIColor.whiteColor()
        
        self.firstNameInput.attributedPlaceholder = NSAttributedString(string:"First name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.lastNameInput.attributedPlaceholder = NSAttributedString(string:"Last name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.headerLabel.text = "Welcome to SAGE!"
        self.subHeaderLabel.text = "What's your name?"
        // set icon and color
        
        let peopleIcon = FAKIonIcons.personIconWithSize(48)
        peopleIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
        let peopleImage = peopleIcon.imageWithSize(CGSizeMake(48, 48))
        self.icon.image = peopleImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let textOffset: CGFloat = 40
        let textFieldHeight: CGFloat = 40
        let dividerMargin: CGFloat = 30
        
        self.firstNameInput.setY(CGRectGetMaxY(self.icon.frame) + 40)
        self.firstNameInput.setX(textOffset + UIConstants.sideMargin)
        self.firstNameInput.setWidth(screenWidth - textOffset * 2 - 2 * UIConstants.sideMargin)
        self.firstNameInput.setHeight(textFieldHeight)
        
        self.firstDivider.setX(dividerMargin + UIConstants.sideMargin)
        self.firstDivider.setY(CGRectGetMaxY(self.firstNameInput.frame))
        self.firstDivider.setWidth(screenWidth - 2 * dividerMargin - 2 * UIConstants.sideMargin)
        self.firstDivider.setHeight(UIConstants.dividerHeight())
        
        self.lastNameInput.setY(CGRectGetMaxY(self.firstNameInput.frame) + 10)
        self.lastNameInput.setX(textOffset + UIConstants.sideMargin)
        self.lastNameInput.setWidth(screenWidth - textOffset * 2 - 2 * UIConstants.sideMargin)
        self.lastNameInput.setHeight(textFieldHeight)
        
        self.secondDivider.setX(dividerMargin + UIConstants.sideMargin)
        self.secondDivider.setY(CGRectGetMaxY(self.lastNameInput.frame))
        self.secondDivider.setWidth(screenWidth - 2 * dividerMargin - 2 * UIConstants.sideMargin)
        self.secondDivider.setHeight(UIConstants.dividerHeight())
        
    }
}
