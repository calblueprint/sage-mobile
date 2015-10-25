//
//  SignUpFormView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpFormView: UIView {
    var headerLabel: UILabel = UILabel()
    var subHeaderLabel: UILabel = UILabel()
    var icon: UIImageView = UIImageView()
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
        
        // set colors and stuff
        self.headerLabel.textColor = UIColor.whiteColor()
        self.headerLabel.font = UIFont.getTitleFont(36)
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
        
        self.headerLabel.setY(85)
        self.headerLabel.sizeToFit()
        self.headerLabel.centerHorizontally()
        
        self.subHeaderLabel.setY(CGRectGetMaxY(self.headerLabel.frame))
        self.subHeaderLabel.sizeToFit()
        self.subHeaderLabel.centerHorizontally()
        
        self.icon.setY(CGRectGetMaxY(self.subHeaderLabel.frame) + 20)
        self.icon.setWidth(58)
        self.icon.setHeight(58)
        self.icon.centerHorizontally()
        
    }
}
