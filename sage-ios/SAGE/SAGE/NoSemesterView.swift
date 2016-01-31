//
//  JoinSemesterView.swift
//  SAGE
//
//  Created by Erica Yin on 1/29/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class NoSemesterView: UIView {
    
    let content = UIView()
    let message = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.content)
        self.content.addSubview(self.message)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        self.message.text = "Check Ins are unavailable because the current semester has not started yet."
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
    }
    
}