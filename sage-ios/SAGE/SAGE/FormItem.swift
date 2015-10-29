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
    var divider: UIView = UIView()
    var labelHeight: CGFloat = 45.0
    var labelWidth: CGFloat = 100.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label.textColor = UIColor.blackColor()
        self.label.font = UIFont.getSemiboldFont(13)
        self.addSubview(self.label)
        
        self.divider.backgroundColor = UIColor.borderColor
        self.divider.setHeight(UIConstants.dividerHeight())
        self.addSubview(self.divider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.label.setWidth(self.labelWidth)
        self.label.setHeight(self.labelHeight)
        
        self.divider.alignBottomWithMargin(0)
        self.divider.fillWidth()
    }
    
    //
    // MARK:- Public Methods
    //
    func changeThemeColor(color: UIColor) {
        self.label.textColor = color
        self.divider.backgroundColor = color
    }
}