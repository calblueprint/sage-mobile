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
    var containerView: UIView = UIView()
    var profileImage: UIImageView = UIImageView()
    var iconImage: UIImageView = UIImageView()
    var photo: UIImageView = UIImageView()
    var photoBorder: UIView = UIView()
    
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
    
    func setUpViews() {
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.unverifiedLabel)
        self.unverifiedLabel.text = "Thanks for signing up! A request has been sent to SAGE for approval."
        self.unverifiedLabel.font = UIFont.titleFont
        self.unverifiedLabel.textColor = UIColor.blackColor()
        self.unverifiedLabel.numberOfLines = 3
        self.unverifiedLabel.textAlignment = .Center
        
        self.containerView.addSubview(self.profileImage)
        
        let checkmarkIcon = FAKIonIcons.checkmarkCircledIconWithSize(170)
        checkmarkIcon.setAttributes([NSForegroundColorAttributeName: UIColor.lightGreenColor])
        let checkmarkImage = checkmarkIcon.imageWithSize(CGSizeMake(170, 170))
        self.iconImage.image = checkmarkImage
        self.containerView.addSubview(self.iconImage)
        
        self.containerView.addSubview(self.photoBorder)
        self.photoBorder.layer.cornerRadius = 40
        self.photoBorder.clipsToBounds = true
        self.photoBorder.backgroundColor = UIColor.whiteColor()
        
        self.containerView.addSubview(self.photo)
        self.photo.layer.cornerRadius = 35
        self.photo.clipsToBounds = true
        self.photo.contentMode = .ScaleAspectFit
        
        let personIcon = FAKIonIcons.personIconWithSize(200)
        personIcon.setAttributes([NSForegroundColorAttributeName: UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
        let personImage = personIcon.imageWithSize(CGSizeMake(200, 200))
        self.photo.image = personImage
        self.photo.clipsToBounds = true
        self.photo.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
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
        
        self.photo.setY(0)
        self.photo.setWidth(70)
        self.photo.setHeight(70)
        self.photo.centerHorizontally()
        self.photo.setX(self.photo.frame.origin.x - 75)

        self.photoBorder.setWidth(80)
        self.photoBorder.setHeight(80)
        self.photoBorder.center = self.photo.center
        
        self.unverifiedLabel.setY(CGRectGetMaxY(self.iconImage.frame) + 20)
        self.unverifiedLabel.setX(40)
        self.unverifiedLabel.setWidth(self.containerView.frame.width - 80)
        self.unverifiedLabel.setHeight(65)
        self.unverifiedLabel.centerHorizontally()
        
    }
}
