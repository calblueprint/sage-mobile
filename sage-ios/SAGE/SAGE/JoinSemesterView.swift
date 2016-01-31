//
//  JoinSemesterView.swift
//  SAGE
//
//  Created by Erica Yin on 1/29/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class JoinSemesterView: UIView {
    
    let content = UIView()
    let button = SGButton()
    let message = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.content)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.content.addSubview(self.message)
        self.content.addSubview(self.button)
        self.backgroundColor = UIColor.whiteColor()
        self.message.text = "You have not joined the current active semester yet."
        self.button.setTitle("Join Semester", forState: .Normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.content.fillWidth()
        self.content.fillHeight()
        
        self.message.font = UIFont.normalFont
        self.message.textAlignment = NSTextAlignment.Center
        self.message.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.message.numberOfLines = 0
        self.message.fillWidthWithMargin(35)
        self.message.sizeToFit()
        self.message.centerInSuperview()
        
        self.button.backgroundColor = UIColor.whiteColor()
        self.button.layer.borderColor = UIColor.borderColor.CGColor
        self.button.layer.borderWidth = 1
        self.button.layer.cornerRadius = 5
        self.button.setThemeColor(UIColor.secondaryTextColor)
        self.button.titleLabel!.font = UIFont.normalFont
        self.button.sizeToFit()
        let width = CGRectGetWidth(self.button.frame)
        self.button.setWidth(width + 10)
        let buttonOffsetY = CGRectGetMaxY(self.message.frame)
        self.button.setY(buttonOffsetY + 20)
        self.button.centerHorizontally()
    }
    
}
