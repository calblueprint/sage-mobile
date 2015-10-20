//
//  CheckinView.swift
//  SAGE
//
//  Created by Andrew on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class CheckinView: UIView {

    var startButton: UIButton = UIButton()
    var endButton: UIButton = UIButton()
    var mapView: GMSMapView = GMSMapView()
    
    private let buttonSize: CGFloat = 56.0
    private let margin: CGFloat = 10.0
    private let shadowOpacity: Float = 0.5

    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.mapView.fillWidth()
        self.mapView.fillHeight()
        
        self.startButton.alignBottomWithMargin(margin * 2 + buttonSize)
        self.startButton.alignRightWithMargin(margin)
        
        self.endButton.alignBottomWithMargin(margin * 2 + buttonSize)
        self.endButton.alignRightWithMargin(margin)
    }
    
    //
    // MARK: - Public methods
    //
    func presentDefaultMode(duration: NSTimeInterval) {
        self.showButton(self.startButton, hide: self.endButton, duration: duration)
    }
    
    func presentSessionMode(duration: NSTimeInterval) {
        self.showButton(self.endButton, hide: self.startButton, duration: duration)
    }
    
    //
    // MARK: - Private methods
    //
    private func setupSubviews() {
        self.addSubview(self.mapView)
        
        let checkSize: CGFloat = 24
        self.startButton.backgroundColor = UIColor.lightGreenColor
        self.startButton.setSize(width: buttonSize, height: buttonSize)
        self.startButton.layer.cornerRadius = buttonSize / 2
        self.addShadowToView(self.startButton)
        let checkIcon: FAKIcon = FAKIonIcons.androidDoneIconWithSize(checkSize)
        checkIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.startButton.setImage(checkIcon.imageWithSize(CGSizeMake(checkSize,checkSize)), forState: .Normal)
        self.addSubview(self.startButton)
        
        let closeSize: CGFloat = 24
        self.endButton.backgroundColor = UIColor.lightRedColor
        self.endButton.setSize(width: buttonSize, height: buttonSize)
        self.endButton.layer.cornerRadius = buttonSize / 2
        self.addShadowToView(self.endButton)
        let closeIcon: FAKIcon = FAKIonIcons.androidCloseIconWithSize(closeSize)
        closeIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.endButton.setImage(closeIcon.imageWithSize(CGSizeMake(checkSize,checkSize)), forState: .Normal)
        self.addSubview(self.endButton)
    }
    
    private func showButton(buttonShow: UIButton, hide buttonHide: UIButton, duration: NSTimeInterval) {
        buttonShow.transform = CGAffineTransformMakeScale(0.05, 0.05)
        buttonShow.alpha = 1
        self.bringSubviewToFront(buttonShow)
        
        UIView.animateWithDuration(duration,
            delay: 0,
            usingSpringWithDamping: UIConstants.defaultSpringDampening,
            initialSpringVelocity: UIConstants.defaultSpringVelocity,
            options:.CurveEaseInOut,
            animations: { () -> Void in
                buttonShow.transform = CGAffineTransformIdentity
                buttonHide.alpha = 0
            }) { (complete: Bool) -> Void in }
    }
    
    private func addShadowToView(view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0,1)
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = shadowOpacity
    }
}
