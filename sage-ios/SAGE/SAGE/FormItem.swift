//
//  FormItem.swift
//  SAGE
//
//  Created by Andrew on 10/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

//
// ABSTRACT CLASS - DO NOT INSTANTIATE
//
class FormItem: UIView {
    
    var label: UILabel = UILabel()
    var labelHeight: CGFloat = 50.0
    var labelWidth: CGFloat = 100.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.label.textColor = UIColor.blackColor()
        self.label.font = UIFont.semiboldFont
        self.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.setX(UIConstants.textMargin)
        self.label.setWidth(self.labelWidth)
        self.label.setHeight(self.labelHeight)
    }
    
    //
    // MARK:- Public Methods
    //
    func changeThemeColor(color: UIColor) {
        self.label.textColor = color
    }
}