//
//  SignUpFormView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpFormView: UIView {
    var headerLabel: UILabel = UILabel()
    var subHeaderLabel: UILabel = UILabel()
    var icon: UIImageView = UIImageView()
    var xButton: UIButton = UIButton()
    var containerView: UIView = UIView()
    
    override init(frame: CGRect) {
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        let newFrame = CGRectMake(0, 0, screenWidth, screenHeight)
        super.init(frame: newFrame)
        self.setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        // add everything a subview
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.headerLabel)
        self.containerView.addSubview(self.subHeaderLabel)
        self.containerView.addSubview(self.icon)
        self.containerView.addSubview(self.xButton)
        
        // set colors and stuff
        self.headerLabel.textColor = UIColor.whiteColor()
        self.headerLabel.font = UIFont.titleFont
        self.subHeaderLabel.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func layoutSubviews() {
        
        self.containerView.centerHorizontally()
        self.containerView.centerVertically()
        self.containerView.setHeight(self.frame.height)
        self.containerView.setWidth(self.frame.width)
        self.containerView.setX(0)
        self.containerView.setY(0)
        
        self.xButton.setX(0)
        self.xButton.setY(0)
        self.xButton.setWidth(44)
        self.xButton.setHeight(66)
        let xButtonIcon = FAKIonIcons.closeRoundIconWithSize(22).imageWithSize(CGSizeMake(22, 22))
        self.xButton.setImage(xButtonIcon, forState: UIControlState.Normal)
        
        self.headerLabel.setWidth(self.containerView.frame.width)
        self.headerLabel.setX(0)
        self.headerLabel.setY(85)
        self.headerLabel.setHeight(40)
    }
}
