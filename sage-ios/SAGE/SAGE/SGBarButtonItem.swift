//
//  SGBarButtonItem.swift
//  SAGE
//
//  Created by Andrew on 12/1/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class SGBarButtonItem: UIBarButtonItem {

    private let defaultFont = UIFont.getDefaultFont(17)
    private let boldFont = UIFont.getSemiboldFont(17)

    private var customButton = SGButton()

    init(title: String?, style: UIBarButtonItemStyle, target: AnyObject?, action: Selector) {
        super.init()
        if style == UIBarButtonItemStyle.Done {
            self.customButton.titleLabel?.font = boldFont
        } else {
            self.customButton.titleLabel?.font = defaultFont
        }
        self.customButton.setTitle(title, forState: .Normal)
        let width = self.customButton.titleLabel!.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max)).width
        self.customButton.setSize(CGSizeMake(width, UIConstants.barbuttonSize))
        self.customButton.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        self.customView = self.customButton
        self.target = target
        self.action = action
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //
    // MARK: - Public Methods
    //
    func startLoading() {
        self.customButton.startLoading()
    }

    func stopLoading() {
        self.customButton.stopLoading()
    }
}
