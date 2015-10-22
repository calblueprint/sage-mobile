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
    var timerView: UIView = UIView()
    var timerArc: CAShapeLayer = CAShapeLayer()
    var mapView: GMSMapView = GMSMapView()
    
    private let buttonSize: CGFloat = 56.0
    private let timerSize: CGFloat = 80.0
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
        
        self.timerView.setY(margin)
        self.timerView.alignRightWithMargin(margin)
    }
    
    //
    // MARK: - Public methods
    //
    func presentDefaultMode(duration: NSTimeInterval) {
        self.showView(self.startButton, hide: self.endButton, duration: duration)
        UIView.animateWithDuration(duration) { () -> Void in
            self.timerView.alpha = 0
        }
    }
    
    func presentSessionMode(duration: NSTimeInterval) {
        self.showView(self.endButton, hide: self.startButton, duration: duration)
        self.showView(self.timerView, hide: nil, duration: duration)
        self.updateTimerWithTime(20, completionTime: 20)
    }
    
    func updateTimerWithTime(time: NSTimeInterval, completionTime: NSTimeInterval) {
        self.timerArc.path = self.createTimerArcWithPercentage(0.20)
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
        
        self.timerView.backgroundColor = UIColor.whiteColor()
        self.timerView.setSize(width: timerSize, height: timerSize)
        self.timerView.layer.cornerRadius = timerSize/2
        self.timerView.layer.addSublayer(self.timerArc)
        self.addShadowToView(self.timerView)
        self.addSubview(self.timerView)
        
        self.timerArc.fillColor = UIColor.lightRedColor.CGColor
    }
    
    private func showView(showView: UIView, hide hideView: UIView?, duration: NSTimeInterval) {
        showView.transform = CGAffineTransformMakeScale(0.05, 0.05)
        showView.alpha = 1
        self.bringSubviewToFront(showView)
        
        UIView.animateWithDuration(duration,
            delay: 0,
            usingSpringWithDamping: UIConstants.defaultSpringDampening,
            initialSpringVelocity: UIConstants.defaultSpringVelocity,
            options:.CurveEaseInOut,
            animations: { () -> Void in
                showView.transform = CGAffineTransformIdentity
                hideView?.alpha = 0
            }) { (complete: Bool) -> Void in }
    }
    
    private func addShadowToView(view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0,1)
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = shadowOpacity
    }
    
    private func createTimerArcWithPercentage(percentage: CGFloat) -> CGPath {
        let pi: CGFloat = 3.1415926
        let arc = CGPathCreateMutable()
        CGPathMoveToPoint(arc, nil, timerSize/2, 0)
        CGPathAddArc(arc,
            nil,
            timerSize/2, timerSize/2,   // center.x, center.y
            timerSize/2,                // radius
            -pi/2,                      // start angle
            -pi/2 + 2*pi*percentage,    // end angle
            false)                      // counter clockwise?
        let strokedArc = CGPathCreateCopyByStrokingPath(arc, nil,
            5.0,                        // lineWidth
            .Round,                     // line cap
            .Round,                     // edge join
            10)                         // thickness
        return strokedArc!
    }
}
