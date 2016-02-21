//
//  ExpandMenuItem.swift
//  SAGE
//
//  Created by Andrew Millman on 2/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

class ExpandMenuItem<Element>: MenuItem {

    var list = [Element]()

    private var expandCaret = UIImageView()
    private var topDivider = UIView()
    private var expanded = false

    private var originalSubviewIndex = 0
    private var originalYPosition: CGFloat = 0

    //
    // MARK: - Initialization and Setup
    //
    required init(title: String, list:[Element], handler: (AnyObject) -> Void) {
        super.init(title: title, handler: handler)
        self.list = list
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupSubviews() {
        super.setupSubviews()

        self.expandCaret.backgroundColor = UIColor.redColor()
        self.expandCaret.setSize(CGSizeMake(22, 22))
        self.addSubview(self.expandCaret)

        self.topDivider.backgroundColor = UIColor.borderColor
        self.topDivider.setHeight(UIConstants.dividerHeight())
        self.topDivider.alpha = 0
        self.addSubview(self.topDivider)
    }

    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()

        self.expandCaret.alignRightWithMargin(UIConstants.sideMargin)
        self.expandCaret.centerVertically()

        self.topDivider.fillWidth()
    }

    //
    // MARK: - Gesture Recognizer
    //
    override func itemTapped(sender: UIGestureRecognizer) {
        if self.expanded {
            self.expanded = false

            UIView.animateWithDuration(UIConstants.longAnimationTime,
                delay: 0,
                usingSpringWithDamping: UIConstants.defaultSpringDampening,
                initialSpringVelocity: UIConstants.defaultSpringVelocity,
                options: [],
                animations: { () -> Void in
                    self.setY(self.originalYPosition)
                }) { (completed) -> Void in
                    self.superview!.insertSubview(self, atIndex: self.originalSubviewIndex)
                    self.topDivider.alpha = 0
            }
        } else {
            self.expanded = true
            self.originalSubviewIndex = self.superview!.subviews.indexOf(self)!
            self.originalYPosition = CGRectGetMinY(self.frame)
            self.superview!.insertSubview(self, atIndex: self.superview!.subviews.count - 2) // Bring it right under navbar
            self.topDivider.alpha = 1

            UIView.animateWithDuration(UIConstants.longAnimationTime,
                delay: 0,
                usingSpringWithDamping: UIConstants.defaultSpringDampening,
                initialSpringVelocity: UIConstants.defaultSpringVelocity,
                options: [],
                animations: { () -> Void in
                    self.superview!.layoutIfNeeded()
                    self.setY(UIConstants.navbarHeight)
                }) { (completed) -> Void in
            }
        }
    }
}
