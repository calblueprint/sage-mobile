//
//  UnverifiedView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/8/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class UnverifiedView: UIView {
    
    var unverifiedLabel: UILabel = UILabel()
    var changeInfoLabel: UILabel = UILabel()
    var containerView: UIView = UIView()
    var profileImage: UIImageView = UIImageView()
    var iconImage: UIImageView = UIImageView()
    
    required override init(frame: CGRect) {
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        let newFrame = CGRectMake(0, 0, screenWidth, screenHeight)
        super.init(frame: newFrame)
        self.setUpViews()
    }
    
    override func layoutSubviews() {
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        
        self.containerView.setX(UIConstants.sideMargin)
        self.containerView.setWidth(screenWidth - 2 * UIConstants.sideMargin)
        self.containerView.setY(125)
        self.containerView.setHeight(screenHeight - 125)
        
        self.iconImage.setX(0)
        self.iconImage.setY(0)
        self.iconImage.setWidth(170)
        self.iconImage.setHeight(170)
        self.iconImage.centerHorizontally()
        
        self.unverifiedLabel.setY(CGRectGetMaxY(self.iconImage.frame) + 20)
        self.unverifiedLabel.setX(40)
        self.unverifiedLabel.setWidth(self.containerView.frame.width - 80)
        self.unverifiedLabel.setHeight(65)
        self.unverifiedLabel.centerHorizontally()
        
        self.changeInfoLabel.setY(CGRectGetMaxY(self.containerView.frame) - 300)
        self.changeInfoLabel.setX(0)
        self.changeInfoLabel.setWidth(self.containerView.frame.width)
        self.changeInfoLabel.setHeight(40)
        self.centerHorizontally()
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpViews()
    }
    
    func setUpViews() {
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.unverifiedLabel)
        self.unverifiedLabel.text = "Thanks for signing up! A request has been sent to SAGE for approval."
        self.unverifiedLabel.font = UIFont.titleFont
        self.unverifiedLabel.textColor = UIColor.blackColor()
        self.unverifiedLabel.numberOfLines = 3
        self.unverifiedLabel.textAlignment = NSTextAlignment.Center
        
        
        self.containerView.addSubview(self.changeInfoLabel)
        self.changeInfoLabel.text = "Change information"
        self.changeInfoLabel.textColor = UIColor.blueColor()
        self.changeInfoLabel.textAlignment = NSTextAlignment.Center
        
        self.containerView.addSubview(self.profileImage)
        
        let checkmark = FAKIonIcons.checkmarkCircledIconWithSize(170).imageWithSize(CGSizeMake(170, 170))
        self.iconImage.image = checkmark
        self.containerView.addSubview(self.iconImage)
    }
    
}
