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
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()

        self.titleLabel.text = title
        self.handler = handler

        let tapGesture = UITapGestureRecognizer(target: self, action: "itemTapped:")
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        self.setHeight(MenuView.menuItemHeight)

        self.titleLabel.textColor = UIColor.blackColor()
        self.titleLabel.font = UIFont.getSemiboldFont(16)
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

        self.titleLabel.setX(UIConstants.sideMargin)
        self.titleLabel.fillWidth()
        self.titleLabel.fillHeight()

        self.divider.fillWidth()
        self.divider.alignBottomWithMargin(0)
    }

    //
    // MARK: - Gesture Recognizer
    //
    func itemTapped(sender: UIGestureRecognizer) {
        self.controller?.dismiss()
        self.handler(NSObject())
    }
}