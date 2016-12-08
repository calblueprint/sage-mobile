//
//  ProfileCheckinSummaryView.swift
//  SAGE
//
//  Created by Erica Yin on 3/12/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation
import FontAwesomeKit

class ProfileCheckinSummaryView: UIView {
    
    let topBorder = UIView()
    let bottomBorder = UIView()
    let centerBorder = UIView()
    let userStatusLabel = UILabel()
    let userStatusIcon = UIImageView()
    let userCommitmentLabel = UILabel()
    let userCommitmentIcon = UIImageView()
    let progressContainer = UIView()
    let hoursPercentageLabel = UILabel()
    let sideMargin = CGFloat(30)
    let titleFontSize = CGFloat(22)
    let boxHeight = CGFloat(100)
    let iconSize = CGFloat(14)
    private let timerSize: CGFloat = 60.0
    var progressView: UIView = UIView()
    var progressLabel: UILabel = UILabel()
    var progressArc: CAShapeLayer = CAShapeLayer()
    var completedProgressArc: CAShapeLayer = CAShapeLayer()
    let userStatusString = "User Status String"
    let userCommitmentString = "User Commitment String"
    
    private func createArcWithPercentage(percentage: CGFloat) -> CGPath {
        let pi: CGFloat = CGFloat(M_PI)
        let arc = CGPathCreateMutable()
        CGPathMoveToPoint(arc, nil, self.timerSize/2, 0)
        CGPathAddArc(arc,
            nil,
            self.timerSize/2, self.timerSize/2,             // center.x, center.y
            self.timerSize/2,                               // radius
            -pi/2,                                          // start angle
            -pi/2 + min(2*pi, max(0.30,2*pi*percentage)),   // end angle
            false)                                          // counter clockwise?
        let strokedArc = CGPathCreateCopyByStrokingPath(arc, nil,
            5.0,                                            // lineWidth
            .Round,                                         // line cap
            .Round,                                         // edge join
            10)                                             // thickness
        return strokedArc!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.topBorder)
        self.addSubview(self.bottomBorder)
        self.addSubview(self.progressContainer)
        self.progressContainer.addSubview(self.hoursPercentageLabel)
        self.progressContainer.addSubview(self.progressView)
        self.progressView.layer.addSublayer(self.progressArc)
        self.progressView.layer.addSublayer(self.completedProgressArc)
        self.addSubview(self.userCommitmentLabel)
        self.addSubview(self.userCommitmentIcon)
        self.addSubview(self.userStatusLabel)
        self.addSubview(self.userStatusIcon)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithUser(user: User, pastSemester: Bool = false) {
        var progressArcColor = UIColor.lightGrayColor.CGColor
        if let semesterSummary = user.semesterSummary {
            self.userStatusLabel.font = UIFont.normalFont
            let userStatusString = NSMutableAttributedString(string: semesterSummary.getTotalHoursAsString() + " of " + String(semesterSummary.hoursRequired) + " hours completed")
            self.userStatusLabel.attributedText = userStatusString
            var hoursCompletedPercentage = Float(0)
            if (semesterSummary.hoursRequired != 0) {
                hoursCompletedPercentage = Float(semesterSummary.getTotalHours())/Float(semesterSummary.hoursRequired) * 100.0
            } else if (semesterSummary.getTotalHours() > 0) {
                hoursCompletedPercentage = Float(100)
            }
            self.hoursPercentageLabel.text = String(Int(hoursCompletedPercentage)) + "%"
            
            self.userStatusIcon.image = FAKIonIcons.checkmarkIconWithSize(iconSize)
                .imageWithSize(CGSizeMake(iconSize, iconSize))
            if pastSemester {
                if semesterSummary.completed {
                    progressArcColor = UIColor.lightGreenColor.CGColor
                } else {
                    progressArcColor = UIColor.lightRedColor.CGColor
                }
            }
            if hoursCompletedPercentage == 0 {
                progressArcColor = UIColor.lighterGrayColor.CGColor
            }
            self.completedProgressArc.path = self.createArcWithPercentage(CGFloat(min(1, hoursCompletedPercentage/(100.0)) * 0.75))
        } else {
            self.userStatusLabel.font = UIFont.normalFont
            self.userStatusLabel.text = "Inactive"
            self.hoursPercentageLabel.text = "0%"
            self.userStatusIcon.image = FAKIonIcons.flagIconWithSize(self.iconSize)
                .imageWithSize(CGSizeMake(self.iconSize, self.iconSize))
            progressArcColor = UIColor.lighterGrayColor.CGColor
        }
        
        let weeklyHoursRequiredString = String(user.getRequiredHours())
        let userCommitmentString = NSMutableAttributedString(string: weeklyHoursRequiredString + " hours per week")
        self.userCommitmentLabel.attributedText = userCommitmentString
        self.userCommitmentIcon.image = FAKIonIcons.androidTimeIconWithSize(iconSize)
            .imageWithSize(CGSizeMake(iconSize, iconSize))
        
        self.completedProgressArc.fillColor = progressArcColor
        self.progressArc.fillColor = UIColor.lighterGrayColor.CGColor
        self.topBorder.backgroundColor = UIColor.borderColor
        
        layoutSubviews()
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        
        self.topBorder.setHeight(UIConstants.dividerHeight())
        self.topBorder.backgroundColor = UIColor.whiteColor()
        
        self.bottomBorder.setHeight(UIConstants.dividerHeight())
        self.bottomBorder.backgroundColor = UIColor.borderColor
        
        self.progressContainer.setWidth(self.timerSize)
        self.progressContainer.setHeight(self.timerSize)
        
        self.hoursPercentageLabel.font = UIFont.normalFont
        self.hoursPercentageLabel.textColor = UIColor.grayColor()
        self.hoursPercentageLabel.frame = CGRectIntegral(self.hoursPercentageLabel.frame)
        
        self.progressView.setWidth(self.timerSize)
        self.progressView.setHeight(self.timerSize)
        self.progressView.layer.cornerRadius = self.timerSize/2
        self.progressArc.fillColor = UIColor.whiteColor().CGColor
        self.progressArc.path = self.createArcWithPercentage(3/4)
        
        self.completedProgressArc.path = self.createArcWithPercentage(0)
        self.completedProgressArc.fillColor = UIColor.whiteColor().CGColor
        
        self.userStatusLabel.font = UIFont.normalFont
        self.userStatusLabel.setHeight(30)
        
        self.userCommitmentLabel.font = UIFont.normalFont
        self.userCommitmentLabel.setHeight(30)
        
        self.userStatusIcon.setSize(width: 20, height: 30)
        self.userStatusIcon.contentMode = .Center
        self.userStatusIcon.image = UIImage()
        
        self.userCommitmentIcon.setSize(width: 20, height: 30)
        self.userCommitmentIcon.contentMode = .Center
        self.userCommitmentIcon.image = UIImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.topBorder.fillWidth()
        self.topBorder.setX(0)
        self.topBorder.setY(0)
        
        self.bottomBorder.fillWidth()
        self.bottomBorder.setX(0)
        self.bottomBorder.setY(self.boxHeight)
        
        self.progressView.transform = CGAffineTransformIdentity
        self.progressView.setX(0)
        self.progressView.centerVertically()
        self.progressView.transform = CGAffineTransformMakeRotation(-3*CGFloat(M_PI)/4)
        
        let progressViewX = CGRectGetWidth(self.bottomBorder.frame) - CGRectGetWidth(self.progressView.frame)
        self.progressContainer.setX(progressViewX)
        self.progressContainer.centerVertically()
        
        self.hoursPercentageLabel.sizeToFit()
        self.hoursPercentageLabel.centerInSuperview()
        
        self.userStatusIcon.setX(UIConstants.sideMargin)
        self.userStatusIcon.alignBottomWithMargin(CGRectGetHeight(self.frame)/2)
        
        self.userCommitmentIcon.setX(CGRectGetMinX(self.userStatusIcon.frame))
        self.userCommitmentIcon.setY(CGRectGetMaxY(self.userStatusIcon.frame))
        
        self.userStatusLabel.setX(CGRectGetMaxX(self.userStatusIcon.frame) + UIConstants.textMargin)
        self.userStatusLabel.alignBottomWithMargin(CGRectGetHeight(self.frame)/2)
        self.userStatusLabel.fillWidthWithMargin(UIConstants.screenWidth - CGRectGetMinX(self.progressContainer.frame))

        self.userCommitmentLabel.setX(CGRectGetMinX(self.userStatusLabel.frame))
        self.userCommitmentLabel.setY(CGRectGetMaxY(self.userStatusLabel.frame))
        self.userCommitmentLabel.fillWidthWithMargin(UIConstants.screenWidth - CGRectGetMinX(self.progressContainer.frame))
        
    }
}
