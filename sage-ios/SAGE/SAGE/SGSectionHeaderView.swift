//
//  SGSectionHeaderView.swift
//  SAGE
//
//  Created by Erica Yin on 4/2/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation
import UIKit

class SGSectionHeaderView: UIView {
    
    let sectionTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.sectionTitle)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sectionTitle.sizeToFit()
        self.sectionTitle.fillWidthWithMargin(UIConstants.textMargin)
        self.sectionTitle.centerVertically()
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.lightestGrayColor
        self.setHeight(26)
        
        self.sectionTitle.setX(UIConstants.textMargin)
        self.sectionTitle.setY(0)
        self.sectionTitle.font = UIFont.semiboldFont
        self.sectionTitle.textColor = UIColor.grayColor()
    }
    
    func setSectionTitle(title: String) {
        self.sectionTitle.text = title
    }
    
}