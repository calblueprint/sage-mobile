//
//  FormTextItem.swift
//  SAGE
//
//  Created by Andrew on 10/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class FormTextItem: FormItem {
    
    var textView: UITextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textView.textColor = UIColor.blackColor()
        self.textView.font = UIFont.getDefaultFont(17)
        self.addSubview(self.textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textView.setX(CGRectGetMaxX(self.label.frame))
        self.textView.fillWidth()
        self.textView.fillHeight()
    }
    
    //
    // MARK:- Public Methods
    //
    override func changeThemeColor(color: UIColor) {
        super.changeThemeColor(color)
        self.textView.textColor = color
    }
}
