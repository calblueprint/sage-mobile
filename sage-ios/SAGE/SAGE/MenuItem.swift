//
//  MenuItem.swift
//  SAGE
//
//  Created by Andrew Millman on 2/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class MenuItem: UIView {
    
    var titleLabel = UILabel()
    var handler: (AnyObject) -> Void = { _ in }
    
    //
    // MARK: - Initialization and Setup
    //
    required init(title: String, handler: (AnyObject) -> Void) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
        
        self.titleLabel.text = title
        self.handler = handler
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.setHeight(MenuView.menuItemHeight)
        
        self.titleLabel.textColor = UIColor.blackColor()
        self.titleLabel.font = UIFont.getSemiboldFont(16)
        self.addSubview(self.titleLabel)
    }
    
    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.setX(UIConstants.sideMargin)
        self.titleLabel.fillWidth()
        self.titleLabel.fillHeight()
    }
}