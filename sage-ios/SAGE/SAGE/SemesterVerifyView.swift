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
    private var firstButtonDone = false

    private let secondButtonRipple = UIView()
    private let secondButton = UIView()
    private let secondButtonLabel = UILabel()
    private var secondButtonDone = false

    private let progressBar = UIView()

    private let finalButton = SGButton()

    private let buttonSize: CGFloat = 70.0
    private let buttonMargin: CGFloat = 50.0
    private let rippleSize: CGFloat =
        sqrt(2*UIConstants.screenWidth*UIConstants.screenWidth + 2*UIConstants.screenHeight*UIConstants.screenHeight)
    private let labelHeight: CGFloat = 100.0

    private let labelMoveDistance: CGFloat = 25.0
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

        self.cancelButton.setWidth(UIConstants.barbuttonSize)
        self.cancelButton.setHeight(UIConstants.barbuttonSize)
        let cancelButtonIcon = FAKIonIcons.closeRoundIconWithSize(UIConstants.barbuttonIconSize)
        cancelButtonIcon.setAttributes([NSForegroundColorAttributeName: UIColor.blackColor()])
        let cancelButtonImage = cancelButtonIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        self.cancelButton.setImage(cancelButtonImage, forState: UIControlState.Normal)
        self.addSubview(self.cancelButton)

        self.firstButtonRipple.backgroundColor = UIColor.lightRedColor
        self.firstButtonRipple.setSize(width: self.rippleSize, height: self.rippleSize)
        self.firstButtonRipple.layer.cornerRadius = self.rippleSize/2
        self.firstButtonRipple.transform = CGAffineTransformMakeScale(buttonSize/rippleSize, buttonSize/rippleSize)
        self.addSubview(self.firstButtonRipple)

        self.firstButton.backgroundColor = UIColor.lightRedColor
        self.firstButton.setSize(width: self.buttonSize, height: self.buttonSize)
        self.firstButton.layer.cornerRadius = self.buttonSize/2
        self.addSubview(self.firstButton)

        self.firstButtonLabel.font = UIFont.getTitleFont(40)
        self.firstButtonLabel.alpha = 0
        self.firstButtonLabel.textAlignment = .Center
        self.firstButtonLabel.numberOfLines = 0
        let firstAttributedText = NSMutableAttributedString(string: "First, press the \nred button.")
        firstAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightRedColor, range: NSMakeRange(18, 3))
        self.firstButtonLabel.attributedText = firstAttributedText
        self.addSubview(firstButtonLabel)

        self.secondButtonRipple.backgroundColor = UIColor.lightBlueColor
        self.secondButtonRipple.setSize(width: self.rippleSize, height: self.rippleSize)
        self.secondButtonRipple.layer.cornerRadius = self.rippleSize/2
        self.secondButtonRipple.transform = CGAffineTransformMakeScale(buttonSize/rippleSize, buttonSize/rippleSize)
        self.addSubview(self.secondButtonRipple)

        self.secondButton.backgroundColor = UIColor.lightBlueColor
        self.secondButton.setSize(width: self.buttonSize, height: self.buttonSize)
        self.secondButton.layer.cornerRadius = self.buttonSize/2
        self.addSubview(self.secondButton)

        self.secondButtonLabel.font = UIFont.getTitleFont(40)
        self.secondButtonLabel.alpha = 0
        self.secondButtonLabel.textAlignment = .Center
        self.secondButtonLabel.numberOfLines = 0
        let secondAttributedText = NSMutableAttributedString(string: "Now, press the \nblue button.")
        secondAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightBlueColor, range: NSMakeRange(16, 4))
        self.secondButtonLabel.attributedText = secondAttributedText
        self.addSubview(secondButtonLabel)

        self.progressBar.setHeight(5)
        self.addSubview(self.progressBar)

        self.finalButton.setWidth(100)
        self.finalButton.setHeight(50)
        self.finalButton.setTitle("Proceed!", forState: .Normal)
        self.finalButton.backgroundColor = UIColor.lightGreenColor
        self.finalButton.layer.cornerRadius = 5
        self.finalButton.alpha = 0
    }

    private func setupActions() {
        let firstBeginRecognizer = UILongPressGestureRecognizer(target: self, action: "firstButtonPressed:")
        firstBeginRecognizer.minimumPressDuration = 0.01
        self.firstButton.addGestureRecognizer(firstBeginRecognizer)

        let secondBeginRecognizer = UILongPressGestureRecognizer(target: self, action: "secondButtonPressed:")
        secondBeginRecognizer.minimumPressDuration = 0.01
        self.secondButton.addGestureRecognizer(secondBeginRecognizer)
    }

    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()

        self.cancelButton.setX(8)
        self.cancelButton.setY(UIConstants.statusBarHeight)

        self.firstButton.setX(self.buttonMargin)
        self.firstButton.alignBottomWithMargin(self.buttonMargin)

        self.firstButtonRipple.center = self.firstButton.center

        self.firstButtonLabel.setY(UIConstants.navbarHeight)
        self.firstButtonLabel.fillWidth()
        self.firstButtonLabel.setHeight(self.labelHeight)

        self.secondButton.alignRightWithMargin(self.buttonMargin)
        self.secondButton.alignBottomWithMargin(self.buttonMargin)

        self.secondButtonRipple.center = self.secondButton.center

        self.secondButtonLabel.setY(UIConstants.navbarHeight)
        self.secondButtonLabel.fillWidth()
        self.secondButtonLabel.setHeight(self.labelHeight)

        self.progressBar.setY(CGRectGetMaxY(self.firstButtonLabel.frame) + UIConstants.textMargin)

        self.finalButton.centerInSuperview()
    }

    //
    // MARK: - Gesture Recognizers
    //
    @objc private func firstButtonPressed(sender: UIGestureRecognizer!) { // Begin long pressing
        if sender.state == .Began {
            self.animateProgress(self.firstButtonRipple, button: self.firstButton)
        } else if sender.state == .Ended {
            if !self.firstButtonDone {
                self.cancelProgressBar()
            }
        }
    }

    @objc private func secondButtonPressed(sender: UIGestureRecognizer!) { // Begin long pressing
        if self.firstButtonDone {
            if sender.state == .Began {
                self.animateProgress(self.secondButtonRipple, button: self.secondButton)
            }  else if sender.state == .Ended {
                if !self.secondButtonDone {
                    self.cancelProgressBar()
                }
            }
        }
    }

    //
    // MARK: - Public Methods
    //
    func showFirstLabel() {
        self.showLabel(self.firstButtonLabel)
    }

    //
    // MARK: - Private Methods
    //
    private func animateProgress(ripple: UIView, button: UIView) {
        self.progressBar.backgroundColor = button.backgroundColor
        self.progressBar.setWidth(0)
        self.progressBar.alpha = 1
        UIView.animateWithDuration(self.minimumDuration, delay: 0, options: .CurveLinear, animations: { () -> Void in
            self.progressBar.fillWidth()
            }) { (completed) -> Void in
                if completed {
                    self.rippleView(ripple, button: button)
                    self.cancelProgressBar()
                    if button == self.firstButton {
                        self.firstButtonDone = true
                        self.hideLabel(self.firstButtonLabel)
                    } else {
                        self.secondButtonDone = true
                        self.hideLabel(self.secondButtonLabel)
                    }
                }
        }
    }

    private func rippleView(ripple: UIView, button: UIView) {
        button.alpha = 0
        ripple.transform = CGAffineTransformMakeScale(buttonSize/rippleSize, buttonSize/rippleSize)
        UIView.animateWithDuration(self.minimumDuration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            ripple.transform = CGAffineTransformIdentity
            ripple.alpha = 0
            }) { (completed) -> Void in
                if button == self.firstButton {
                    self.showLabel(self.secondButtonLabel)
                }
        }
    }

    private func showLabel(label: UILabel) {
        label.alpha = 0
        label.moveY(-self.labelMoveDistance)
        UIView.animateWithDuration(UIConstants.normalAnimationTime, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            label.alpha = 1
            label.moveY(self.labelMoveDistance)
            }, completion: nil)
    }

    private func hideLabel(label: UILabel) {
        UIView.animateWithDuration(UIConstants.normalAnimationTime, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            label.alpha = 0
            }, completion: nil)
    }


    private func cancelProgressBar() {
        self.progressBar.frame = self.progressBar.layer.presentationLayer()!.frame // Preserve the current frame in the animation
        self.progressBar.layer.removeAllAnimations()
        UIView.animateWithDuration(UIConstants.normalAnimationTime, animations: { () -> Void in
            self.progressBar.alpha = 0
        })
    }
}
