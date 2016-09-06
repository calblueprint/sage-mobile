//
//  MenuItem.swift
//  SAGE
//
//  Created by Andrew Millman on 2/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class MenuItem: UIView {

    private(set) var handler: (AnyObject) -> Void = { _ in }
    weak var controller: MenuController?

    private var titleLabel = UILabel()
    private var divider = UIView()

    //
    // MARK: - Initialization and Setup
    //
    required init(title: String, handler: (AnyObject) -> Void) {
        super.init(frame: CGRect.zero)
        self.setupSubviews()

        self.titleLabel.text = title
        self.handler = handler

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MenuItem.itemTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        self.titleLabel.addGestureRecognizer(tapGesture)
        self.titleLabel.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        self.setHeight(MenuView.menuItemHeight)

        self.titleLabel.backgroundColor = UIColor.whiteColor()
        self.titleLabel.textColor = UIColor.blackColor()
        self.titleLabel.font = UIFont.getDefaultFont(15)
        self.titleLabel.textAlignment = .Center
        self.addSubview(self.titleLabel)

        self.divider.backgroundColor = UIColor.borderColor
        self.divider.setHeight(UIConstants.dividerHeight())
        self.addSubview(self.divider)
    }

    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()

        self.titleLabel.setX(0)
        self.titleLabel.fillWidth()
        self.titleLabel.setHeight(MenuView.menuItemHeight)

        self.divider.fillWidth()
        self.divider.setY(CGRectGetMaxY(self.titleLabel.frame) - UIConstants.dividerHeight())
    }

    //
    // MARK: - Gesture Recognizer
    //
    func itemTapped(sender: UIGestureRecognizer) {
        self.controller?.dismiss()
        self.handler(NSObject())
    }
}