//
//  SemesterVerifyView.swift
//  SAGE
//
//  Created by Andrew on 1/1/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit
import Darwin
import FontAwesomeKit

class SemesterVerifyView: UIView {

    let cancelButton = UIButton()

    private let firstButtonRipple = UIView()
    private let firstButton = UIView()
    private let firstButtonLabel = UILabel()

    private let secondButtonRipple = UIView()
    private let secondButton = UIView()
    private let secondButtonLabel = UILabel()

    private let buttonSize: CGFloat = 70.0
    private let buttonMargin: CGFloat = 50.0
    private let rippleSize: CGFloat =
        sqrt(2*UIConstants.screenWidth*UIConstants.screenWidth + 2*UIConstants.screenHeight*UIConstants.screenHeight)

    private let minimumDuration: NSTimeInterval = 4.0

    //
    // MARK: - Initialization and Setup
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
        self.setupActions()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupSubviews() {

        self.firstButtonRipple.backgroundColor = UIColor.lightRedColor
        self.firstButtonRipple.setSize(width: self.rippleSize, height: self.rippleSize)
        self.firstButtonRipple.layer.cornerRadius = self.rippleSize/2
        self.firstButtonRipple.transform = CGAffineTransformMakeScale(buttonSize/rippleSize, buttonSize/rippleSize)
        self.addSubview(self.firstButtonRipple)

        self.firstButton.backgroundColor = UIColor.lightRedColor
        self.firstButton.setSize(width: self.buttonSize, height: self.buttonSize)
        self.firstButton.layer.cornerRadius = self.buttonSize/2
        self.addSubview(self.firstButton)

        self.secondButtonRipple.backgroundColor = UIColor.lightBlueColor
        self.secondButtonRipple.setSize(width: self.rippleSize, height: self.rippleSize)
        self.secondButtonRipple.layer.cornerRadius = self.rippleSize/2
        self.secondButtonRipple.transform = CGAffineTransformMakeScale(buttonSize/rippleSize, buttonSize/rippleSize)
        self.addSubview(self.secondButtonRipple)

        self.secondButton.backgroundColor = UIColor.lightBlueColor
        self.secondButton.setSize(width: self.buttonSize, height: self.buttonSize)
        self.secondButton.layer.cornerRadius = self.buttonSize/2
        self.addSubview(self.secondButton)

        self.cancelButton.setWidth(UIConstants.barbuttonSize)
        self.cancelButton.setHeight(UIConstants.barbuttonSize)
        let cancelButtonIcon = FAKIonIcons.closeRoundIconWithSize(UIConstants.barbuttonIconSize)
        cancelButtonIcon.setAttributes([NSForegroundColorAttributeName: UIColor.blackColor()])
        let cancelButtonImage = cancelButtonIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        self.cancelButton.setImage(cancelButtonImage, forState: UIControlState.Normal)
        self.addSubview(self.cancelButton)
    }

    private func setupActions() {
        let firstGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "firstButtonPressed:")
        firstGestureRecognizer.minimumPressDuration = self.minimumDuration
        firstGestureRecognizer.allowableMovement = buttonSize
        self.firstButton.addGestureRecognizer(firstGestureRecognizer)

        let secondGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "secondButtonPressed:")
        secondGestureRecognizer.minimumPressDuration = self.minimumDuration
        secondGestureRecognizer.allowableMovement = buttonSize
        self.secondButton.addGestureRecognizer(secondGestureRecognizer)
    }

    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()

        self.firstButton.setX(self.buttonMargin)
        self.firstButton.alignBottomWithMargin(self.buttonMargin)

        self.firstButtonRipple.center = self.firstButton.center

        self.secondButton.alignRightWithMargin(self.buttonMargin)
        self.secondButton.alignBottomWithMargin(self.buttonMargin)

        self.secondButtonRipple.center = self.secondButton.center

        self.cancelButton.setX(8)
        self.cancelButton.setY(UIConstants.statusBarHeight)
    }

    //
    // MARK: - Gesture Recognizers
    //
    @objc private func firstButtonPressed(sender: UIGestureRecognizer!) {
        if sender.state == .Began {
            self.rippleView(self.firstButtonRipple, button: self.firstButton)
        }
    }

    @objc private func secondButtonPressed(sender: UIGestureRecognizer!) {
        if sender.state == .Began {
            self.rippleView(self.secondButtonRipple, button: self.secondButton)
        }
    }

    //
    // MARK: - Private Methods
    //
    private func rippleView(ripple: UIView, button: UIView) {
        button.alpha = 0
        ripple.transform = CGAffineTransformMakeScale(buttonSize/rippleSize, buttonSize/rippleSize)
        UIView.animateWithDuration(self.minimumDuration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            ripple.transform = CGAffineTransformIdentity
            ripple.alpha = 0
            }) { (completed) -> Void in
                if completed {

                }
        }
    }
}
