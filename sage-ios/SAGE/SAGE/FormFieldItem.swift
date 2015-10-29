//
//  FormFieldItem.swift
//  SAGE
//
//  Created by Andrew on 10/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class FormFieldItem: FormItem {
    
    var textField: UITextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textField.textColor = UIColor.blackColor()
        self.textField.font = UIFont.getDefaultFont(17)
        self.addSubview(self.textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textField.setX(CGRectGetMaxX(self.label.frame))
        self.textField.fillWidth()
        self.textField.fillHeight()
    }
    
    //
    // MARK:- Public Methods
    //
    override func changeThemeColor(color: UIColor) {
        super.changeThemeColor(color)
        self.textField.textColor = color
    }
}
