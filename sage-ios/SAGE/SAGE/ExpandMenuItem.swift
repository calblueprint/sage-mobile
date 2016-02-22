//
//  ExpandMenuItem.swift
//  SAGE
//
//  Created by Andrew Millman on 2/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import FontAwesomeKit

class ExpandMenuItem<Element>: MenuItem {

    var expandedListController: ExpandedTableViewController<Element>

    private var expandCaret = UIImageView()
    private var topDivider = UIView()
    private var listContainerView = UIView()

    private var expanded = false
    private var originalSubviewIndex = 0
    private var originalYPosition: CGFloat = 0

    //
    // MARK: - Initialization and Setup
    //
    required init(title: String, list:[Element], displayText: (Element) -> String, handler: (Element) -> Void) {
        self.expandedListController = ExpandedTableViewController(list: list, displayText: displayText, handler: handler)
        super.init(title: title, handler: {_ in })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupSubviews() {
        super.setupSubviews()

        let caretSize: CGFloat = 18
        let chevron = FAKIonIcons.chevronDownIconWithSize(caretSize)
        chevron.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor)
        let icon = chevron.imageWithSize(CGSizeMake(caretSize, caretSize))
        self.expandCaret.image = icon
        self.expandCaret.contentMode = .Center
        self.expandCaret.setSize(CGSizeMake(caretSize, caretSize))
        self.addSubview(self.expandCaret)

        self.topDivider.backgroundColor = UIColor.borderColor
        self.topDivider.setHeight(UIConstants.dividerHeight())
        self.topDivider.alpha = 0
        self.addSubview(self.topDivider)

        self.listContainerView.backgroundColor = UIColor.whiteColor()
        self.listContainerView.clipsToBounds = true
        self.addSubview(self.listContainerView)
    }

    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()

        self.expandCaret.alignRightWithMargin(UIConstants.sideMargin)
        self.expandCaret.centerVertically()

        self.topDivider.fillWidth()

        self.listContainerView.fillWidth()
        self.listContainerView.setY(CGRectGetHeight(self.frame))
    }

    //
    // MARK: - Gesture Recognizer
    //
    override func itemTapped(sender: UIGestureRecognizer) {
        if self.expanded {
            self.expanded = false

            UIView.animateWithDuration(UIConstants.fastAnimationTime, animations: { () -> Void in
                self.expandCaret.transform = CGAffineTransformIdentity
                }, completion: nil)

            UIView.animateWithDuration(UIConstants.longAnimationTime,
                delay: 0,
                usingSpringWithDamping: UIConstants.defaultSpringDampening,
                initialSpringVelocity: UIConstants.defaultSpringVelocity,
                options: [],
                animations: { () -> Void in
                    self.setY(self.originalYPosition)
                    self.listContainerView.setHeight(0)
                }) { (completed) -> Void in
                    self.superview!.insertSubview(self, atIndex: self.originalSubviewIndex)
                    self.topDivider.alpha = 0
            }
        } else {
            self.expanded = true

            let expandedListHeight = CGRectGetHeight(self.superview!.frame) - CGRectGetHeight(self.frame) - UIConstants.navbarHeight

            self.originalSubviewIndex = self.superview!.subviews.indexOf(self)!
            self.originalYPosition = CGRectGetMinY(self.frame)
            self.superview!.insertSubview(self, atIndex: self.superview!.subviews.count - 2) // Bring it right under navbar
            self.topDivider.alpha = 1
            self.controller?.addChildViewController(self.expandedListController)

            self.listContainerView.addSubview(self.expandedListController.view)
            self.expandedListController.beginAppearanceTransition(true, animated: false)
            self.expandedListController.view.setY(0)
            self.expandedListController.view.fillWidth()
            self.expandedListController.view.setHeight(expandedListHeight)

            UIView.animateWithDuration(UIConstants.fastAnimationTime, animations: { () -> Void in
                let pi: CGFloat = CGFloat(M_PI)
                self.expandCaret.transform = CGAffineTransformMakeRotation(pi)
                }, completion: nil)

            UIView.animateWithDuration(UIConstants.longAnimationTime,
                delay: 0,
                usingSpringWithDamping: UIConstants.defaultSpringDampening,
                initialSpringVelocity: UIConstants.defaultSpringVelocity,
                options: [],
                animations: { () -> Void in
                    self.superview!.layoutIfNeeded()
                    self.setY(UIConstants.navbarHeight)
                    self.listContainerView.setHeight(expandedListHeight)
                }) { (completed) -> Void in
            }
        }
    }

    //
    // MARK: - Bounds Hit Test Adjustment
    //
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {

        // Convert the point to the target view's coordinate system.
        let pointForTargetView = self.listContainerView.convertPoint(point, fromView: self)

        // Allow for any gestures on the listContainerView
        if CGRectContainsPoint(self.listContainerView.bounds, pointForTargetView) {
            return self.listContainerView.hitTest(pointForTargetView, withEvent:event)
        }
        return super.hitTest(point, withEvent: event)
    }
}
