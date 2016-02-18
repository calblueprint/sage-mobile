//
//  ExpandMenuItem.swift
//  SAGE
//
//  Created by Andrew Millman on 2/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class ExpandMenuItem: MenuItem {

    var expandCaret = UIImageView()

    //
    // MARK: - Initialization and Setup
    //
    override func setupSubviews() {
        super.setupSubviews()

        self.expandCaret.backgroundColor = UIColor.redColor()
        self.expandCaret.setSize(CGSizeMake(22, 22))
        self.addSubview(self.expandCaret)
    }

    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()

        self.alignRightWithMargin(UIConstants.sideMargin)
        self.expandCaret.centerVertically()
    }
}
