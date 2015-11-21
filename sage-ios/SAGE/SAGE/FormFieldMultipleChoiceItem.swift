//
//  FormFieldMultipleChoiceItem.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class FormFieldMultipleChoiceItem: FormItem {

    static let defaultHeight: CGFloat = 45.0
    
    var button: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.button.titleLabel?.font = UIFont.normalFont
        self.addSubview(self.button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.button.setX(CGRectGetMaxX(self.label.frame))
        self.button.fillWidthWithMargin(UIConstants.sideMargin)
        self.button.fillHeight()
        
        self.divider.alignBottomWithMargin(0)
    }
    
    //
    // MARK:- Public Methods
    //
    override func changeThemeColor(color: UIColor) {
        super.changeThemeColor(color)
        self.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    override func disable() {
        super.disable()
        self.button.enabled = false
    }

}
