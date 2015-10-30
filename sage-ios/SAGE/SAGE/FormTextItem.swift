//
//  FormTextItem.swift
//  SAGE
//
//  Created by Andrew on 10/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class FormTextItem: FormItem {
    
    static let defaultHeight: CGFloat = 150.0
    
    var textView: UITextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textView.textColor = UIColor.blackColor()
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.font = UIFont.normalFont
        self.addSubview(self.textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textView.setX(CGRectGetMaxX(self.label.frame))
        self.textView.moveX(-5) //Move left to adjust for padding
        self.textView.moveY(2) // Move down to adjust for padding
        self.textView.fillWidthWithMargin(UIConstants.sideMargin)
        self.textView.fillHeight()
        self.divider.alignBottomWithMargin(0)
    }
    
    //
    // MARK: - Public Methods
    //
    override func changeThemeColor(color: UIColor) {
        super.changeThemeColor(color)
        self.textView.textColor = color
    }
}
