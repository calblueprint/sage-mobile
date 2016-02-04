//
//  SignUpSchoolHoursView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpSchoolHoursView: SignUpFormView {
    
    var chooseSchoolButton: UIButton = UIButton()
    var chooseHoursButton: UIButton = UIButton()
    var firstDivider: UIView = UIView()
    var secondDivider: UIView = UIView()
    var chevronOne: UIImageView = UIImageView()
    var chevronTwo: UIImageView = UIImageView()
    
    override func setUpViews() {
        super.setUpViews()
        self.headerLabel.text = "Almost there..."
        self.subHeaderLabel.text = "Which school do you mentor?"
        
        self.containerView.addSubview(self.chooseSchoolButton)
        self.containerView.addSubview(self.chooseHoursButton)
        self.containerView.addSubview(self.firstDivider)
        self.containerView.addSubview(self.secondDivider)
        self.containerView.addSubview(self.chevronOne)
        self.containerView.addSubview(self.chevronTwo)
        
        self.chooseSchoolButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.chooseHoursButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.firstDivider.backgroundColor = UIColor.whiteColor()
        self.secondDivider.backgroundColor = UIColor.whiteColor()
        self.chooseSchoolButton.setTitle("Choose School...", forState: .Normal)
        self.chooseHoursButton.setTitle("Choose Hours...", forState: .Normal)
        self.chooseSchoolButton.contentHorizontalAlignment = .Left
        self.chooseHoursButton.contentHorizontalAlignment = .Left
        
        let erlenmeyerFlaskIcon = FAKIonIcons.erlenmeyerFlaskIconWithSize(48)
        erlenmeyerFlaskIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
        let erlenmeyerFlaskImage = erlenmeyerFlaskIcon.imageWithSize(CGSizeMake(48, 48))

        self.icon.image = erlenmeyerFlaskImage
        
        let chevronIcon = FAKIonIcons.chevronRightIconWithSize(15)
        chevronIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
        let chevronImage = chevronIcon.imageWithSize(CGSizeMake(15, 15))
        self.chevronOne.image = chevronImage
        self.chevronTwo.image = chevronImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let textOffset: CGFloat = 40
        let textFieldHeight: CGFloat = 40
        let dividerMargin: CGFloat = 30
        
        self.chooseSchoolButton.setY(CGRectGetMaxY(self.icon.frame) + 40)
        self.chooseSchoolButton.setX(textOffset + UIConstants.sideMargin)
        self.chooseSchoolButton.setWidth(screenWidth - textOffset * 2 - 2 * UIConstants.sideMargin - 15)
        self.chooseSchoolButton.setHeight(textFieldHeight)
        
        self.chevronOne.setHeight(15)
        self.chevronOne.setWidth(15)
        self.chevronOne.setY(CGRectGetMaxY(self.chooseSchoolButton.frame) - 28)
        self.chevronOne.setX(CGRectGetMaxX(self.chooseSchoolButton.frame))
        
        self.firstDivider.setX(dividerMargin + UIConstants.sideMargin)
        self.firstDivider.setY(CGRectGetMaxY(self.chooseSchoolButton.frame))
        self.firstDivider.setWidth(screenWidth - 2 * dividerMargin - 2 * UIConstants.sideMargin)
        self.firstDivider.setHeight(UIConstants.dividerHeight())
        
        self.chooseHoursButton.setY(CGRectGetMaxY(self.chooseSchoolButton.frame) + 10)
        self.chooseHoursButton.setX(textOffset + UIConstants.sideMargin)
        self.chooseHoursButton.setWidth(screenWidth - textOffset * 2 - 2 * UIConstants.sideMargin)
        self.chooseHoursButton.setHeight(textFieldHeight)
        
        self.chevronTwo.setHeight(15)
        self.chevronTwo.setWidth(15)
        self.chevronTwo.setY(CGRectGetMaxY(self.chooseHoursButton.frame) - 28)
        self.chevronTwo.setX(CGRectGetMaxX(self.chooseHoursButton.frame) - 15)
        
        self.secondDivider.setX(dividerMargin + UIConstants.sideMargin)
        self.secondDivider.setY(CGRectGetMaxY(self.chooseHoursButton.frame))
        self.secondDivider.setWidth(screenWidth - 2 * dividerMargin - 2 * UIConstants.sideMargin)
        self.secondDivider.setHeight(UIConstants.dividerHeight())
    }
}
