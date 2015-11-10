//
//  CheckinView.swift
//  SAGE
//
//  Created by Andrew on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class CheckinView: UIView {

    var startButton: UIButton = UIButton()
    var endButton: UIButton = UIButton()
    var timerView: UIView = UIView()
    var timerLabel: UILabel = UILabel()
    var timerArc: CAShapeLayer = CAShapeLayer()
    var timerBubble: UIView = UIView()
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
        
        self.timerLabel.fillWidth()
        self.timerLabel.fillHeight()
        self.timerLabel.centerInSuperview()
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
    
    func presentSessionMode(duration: NSTimeInterval, timeElapsed: NSTimeInterval = 0, percentage: CGFloat = 0) {
        self.showView(self.endButton, hide: self.startButton, duration: duration)
        self.showView(self.timerView, hide: nil, duration: duration)
        self.timerLabel.textColor = UIColor.lightRedColor
        self.timerArc.fillColor = UIColor.lightRedColor.CGColor
        self.updateTimerWithTime(timeElapsed, percentage: percentage)
    }
    
    func updateTimerWithTime(timeElapsed: NSTimeInterval, percentage: CGFloat) {
        let minutesPassed = (Int(timeElapsed) / 60) % 60
        let hoursPassed = Int(timeElapsed) / 3600
        self.timerLabel.text = String(format:"%d:%02d", hoursPassed, minutesPassed)
        self.timerArc.path = self.createTimerArcWithPercentage(percentage)
        
        // Turn the timer green if min. hours completed
        if percentage > 1.0 {
            self.timerLabel.textColor = UIColor.lightGreenColor
            self.timerArc.fillColor = UIColor.lightGreenColor.CGColor
        }
        
        // Radiate the bubble every 5 seconds
        if (Int(timeElapsed) % 5 == 0) {
            self.timerBubble.transform = CGAffineTransformMakeScale(0.05, 0.05)
            self.timerBubble.alpha = 1
            UIView.animateWithDuration(0.9, delay: 0, options: .CurveLinear, animations: { () -> Void in
                self.timerBubble.transform = CGAffineTransformIdentity
                self.timerBubble.alpha = 0
                }, completion: nil)
        }
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
        self.addShadowToView(self.timerView)
        self.addSubview(self.timerView)
        
        self.timerLabel.textAlignment = .Center
        self.timerLabel.font = UIFont.systemFontOfSize(22.0)
        self.timerLabel.textColor = UIColor.lightRedColor
        self.timerView.addSubview(self.timerLabel)
        
        self.timerArc.fillColor = UIColor.lightRedColor.CGColor
        self.timerView.layer.addSublayer(self.timerArc)
        
        self.timerBubble.backgroundColor = UIColor(white: 0.90, alpha: 1)
        self.timerBubble.setSize(width: timerSize, height: timerSize)
        self.timerBubble.layer.cornerRadius = timerSize/2
        self.timerView.insertSubview(self.timerBubble, atIndex: 0)
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
        let pi: CGFloat = CGFloat(M_PI)
        let arc = CGPathCreateMutable()
        CGPathMoveToPoint(arc, nil, timerSize/2, 0)
        CGPathAddArc(arc,
            nil,
            timerSize/2, timerSize/2,   // center.x, center.y
            timerSize/2,                // radius
            -pi/2,                      // start angle
            -pi/2 + min(2*pi, max(0.30,2*pi*percentage)),    // end angle
            false)                      // counter clockwise?
        let strokedArc = CGPathCreateCopyByStrokingPath(arc, nil,
            5.0,                        // lineWidth
            .Round,                     // line cap
            .Round,                     // edge join
            10)                         // thickness
        return strokedArc!
    }
}
