//
//  UnverifiedView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/8/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class UnverifiedView: UIView {
    
    var unverifiedLabel: UILabel = UILabel()
    var changeInfoLabel: UILabel = UILabel()
    var containerView: UIView = UIView()
    var profileImage: UIImage = UIImage()
    var iconImage: UIImage = UIImage()
    
    required override init(frame: CGRect) {
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        let newFrame = CGRectMake(0, 0, screenWidth, screenHeight)
        super.init(frame: newFrame)
        self.setUpViews()
    }
    
    override func layoutSubviews() {
        // layout the subviews
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
        self.unverifiedLabel.font = UIFont.normalFont
        
        
        self.containerView.addSubview(self.changeInfoLabel)
        self.changeInfoLabel.text = "Change information"
        self.changeInfoLabel.textColor = UIColor.blueColor()
    }
}
