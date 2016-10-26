//
//  SGNotificationCircle.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 7/16/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SGNotificationCircle: UIView {
    
    var numberLabel = UILabel()
    
    init(number: Int) {
        super.init(frame: CGRectMake(0, 0, 20, 20))
        
        self.addSubview(self.numberLabel)
        self.setHeight(20)
        self.setWidth(20)
        
        self.numberLabel.text = String(number)
        self.numberLabel.setHeight(20)
        self.numberLabel.setWidth(20)
        self.numberLabel.textAlignment = .Center
        self.numberLabel.textColor = UIColor.whiteColor()
        self.numberLabel.font = UIFont.metaFont
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width/2
        
        self.backgroundColor = UIColor.lightRedColor
    }
    
    func setNumber(number: Int) {
        self.numberLabel.text = String(number)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.numberLabel.fillHeight()
        self.numberLabel.fillWidth()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
