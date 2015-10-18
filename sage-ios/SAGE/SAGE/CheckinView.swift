//
//  CheckinView.swift
//  SAGE
//
//  Created by Andrew on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class CheckinView: UIView {

    var mapView: GMSMapView = GMSMapView()
    var startButton: UIButton = UIButton()
    var endButton: UIButton = UIButton()
    
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
    func animateToStartMode(duration: NSTimeInterval) {
        self.showButton(self.startButton, hide: self.endButton, duration: duration)
    }
    
    func animateToEndMode(duration: NSTimeInterval) {
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
    
    private func addShadowToView(view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0,1)
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = shadowOpacity
    }
    
    private func showButton(buttonShow: UIButton, hide buttonHide: UIButton, duration: NSTimeInterval) {
        buttonShow.moveX(buttonSize/2)
        buttonShow.moveY(buttonSize/2)
        buttonShow.setSize(width: 0, height: 0)
        buttonShow.imageView?.centerInSuperview()
        buttonShow.alpha = 1
        buttonShow.layer.shadowOpacity = 0
        self.bringSubviewToFront(buttonShow)
        
        let layerAnimation = CABasicAnimation(keyPath: "cornerRadius")
        layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        layerAnimation.fromValue = 0
        layerAnimation.toValue = buttonSize/2
        layerAnimation.duration = duration
        buttonShow.layer.addAnimation(layerAnimation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(duration, delay: 0, options:.CurveEaseIn, animations: { () -> Void in
            buttonShow.moveX(-self.buttonSize/2)
            buttonShow.moveY(-self.buttonSize/2)
            buttonShow.setSize(width: self.buttonSize, height: self.buttonSize)
            buttonShow.imageView?.centerInSuperview()
            
            }) { (complete: Bool) -> Void in
                buttonShow.layer.shadowOpacity = self.shadowOpacity
                buttonHide.alpha = 0
        }

    }
}
