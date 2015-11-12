//
//  FormFieldItem.swift
//  SAGE
//
//  Created by Andrew on 10/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class FormFieldItem: FormItem {
    
    static let defaultHeight: CGFloat = 45.0
    
    var textField: UITextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textField.textColor = UIColor.blackColor()
        self.textField.font = UIFont.normalFont
        self.addSubview(self.textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textField.setX(CGRectGetMaxX(self.label.frame))
        self.textField.fillWidthWithMargin(UIConstants.sideMargin)
        self.textField.fillHeight()
        
        self.divider.alignBottomWithMargin(0)
    }
    
    //
    // MARK:- Public Methods
    //
    override func changeThemeColor(color: UIColor) {
        super.changeThemeColor(color)
        self.textField.textColor = color
    }
    
    override func disable() {
        super.disable()
        self.textField.enabled = false
    }
}
