//
//  SGNotificationCircleView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 7/16/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//
import UIKit

class SGNotificationCircleView: UIView {
    
    var numberLabel = UILabel()
    private var size: CGFloat = 20
    
    init(number: Int) {
        super.init(frame: CGRectMake(0, 0, size, size))
        
        self.addSubview(self.numberLabel)
        self.setHeight(size)
        self.setWidth(size)
        
        self.numberLabel.text = String(number)
        self.numberLabel.setHeight(size)
        self.numberLabel.setWidth(size)
        self.numberLabel.textAlignment = .Center
        self.numberLabel.textColor = UIColor.whiteColor()
        self.numberLabel.font = UIFont.strongFont
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width/2
        
        let redLayer = CALayer()
        redLayer.frame = self.bounds
        redLayer.backgroundColor = UIColor.lightRedColor.CGColor
        self.layer.insertSublayer(redLayer, atIndex: 0)
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
