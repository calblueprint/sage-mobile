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
    let userInformationContainer = UIView()
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
    var timerView: UIView = UIView()
    var timerLabel: UILabel = UILabel()
    var timerArc: CAShapeLayer = CAShapeLayer()
    var progressArc: CAShapeLayer = CAShapeLayer()
    
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
        self.progressContainer.addSubview(self.timerView)
        self.timerView.layer.addSublayer(self.timerArc)
        self.timerView.layer.addSublayer(self.progressArc)
        self.addSubview(self.userInformationContainer)
        self.userInformationContainer.addSubview(self.userCommitmentLabel)
        self.userInformationContainer.addSubview(self.userCommitmentIcon)
        self.userInformationContainer.addSubview(self.userStatusLabel)
        self.userInformationContainer.addSubview(self.userStatusIcon)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleAttributedString(name: String, string: NSMutableAttributedString, length: Int, userHoursStringColor: UIColor = UIColor.blackColor()) {
        let boldString = [NSFontAttributeName: UIFont.getSemiboldFont(30)]
        
        if name == self.userStatusString {
            string.addAttributes(boldString, range: NSRange(location: 0, length: length))
            string.addAttribute(NSForegroundColorAttributeName, value: userHoursStringColor, range: NSRange(location: 0, length: length))
            let remainderLocation = string.length - 5
            string.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor, range: NSRange(location: remainderLocation, length: 5))
        }
        
        if name == self.userCommitmentString {
            string.addAttributes(boldString, range: NSRange(location: 0, length: length))
            string.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor, range: NSRange(location: 3, length: 10))
        }
    }
    
    func setupWithUser(user: User, pastSemester: Bool = false) {
        if let semesterSummary = user.semesterSummary {
            self.userStatusLabel.font = UIFont.normalFont
            let hoursCompletedString = String(semesterSummary.getTotalHours())
            let userStatusString = NSMutableAttributedString(string: hoursCompletedString + " of " + String(semesterSummary.hoursRequired) + " hours completed")
            var userHoursStringColor = UIColor.blackColor()
            if pastSemester {
                if semesterSummary.completed {
                    userHoursStringColor = UIColor.lightGreenColor
                } else {
                    userHoursStringColor = UIColor.lightRedColor
                }
            }
            self.userStatusLabel.attributedText = userStatusString
            let hoursCompletedPercentage = Float(semesterSummary.getTotalHours())/Float(semesterSummary.hoursRequired)
            self.hoursPercentageLabel.text = String(Int(hoursCompletedPercentage * 100)) + "%"
            self.userStatusIcon.image = FAKIonIcons.checkmarkIconWithSize(iconSize)
                .imageWithSize(CGSizeMake(iconSize, iconSize))
            self.progressArc.path = self.createArcWithPercentage(CGFloat(hoursCompletedPercentage * 0.75))
        } else {
            self.userStatusLabel.font = UIFont.normalFont
            self.userStatusLabel.text = "Inactive"
            self.hoursPercentageLabel.text = "0%"
            self.userStatusIcon.image = FAKIonIcons.flagIconWithSize(self.iconSize)
                .imageWithSize(CGSizeMake(self.iconSize, self.iconSize))
        }
        
        let weeklyHoursRequiredString = String(user.getRequiredHours())
        let userCommitmentString = NSMutableAttributedString(string: weeklyHoursRequiredString + " hours per week")
        self.userCommitmentLabel.attributedText = userCommitmentString
        
        layoutSubviews()
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        
        self.topBorder.setHeight(UIConstants.dividerHeight())
        self.topBorder.backgroundColor = UIColor.borderColor
        
        self.bottomBorder.setHeight(UIConstants.dividerHeight())
        self.bottomBorder.backgroundColor = UIColor.borderColor
        
        self.progressContainer.setWidth(self.timerSize)
        self.progressContainer.setHeight(self.timerSize)
        
        self.hoursPercentageLabel.font = UIFont.normalFont
        
        self.timerView.setWidth(self.timerSize)
        self.timerView.setHeight(self.timerSize)
        self.timerView.layer.cornerRadius = self.timerSize/2
        self.timerArc.fillColor = UIColor.lighterGrayColor.CGColor
        self.timerArc.path = self.createArcWithPercentage(3/4)
        
        self.progressArc.fillColor = UIColor.lightGrayColor.CGColor
        self.progressArc.path = self.createArcWithPercentage(0)
        
        self.userCommitmentLabel.font = UIFont.normalFont
        self.userStatusLabel.font = UIFont.normalFont
        
        self.userStatusIcon.image = FAKIonIcons.checkmarkIconWithSize(self.iconSize)
            .imageWithSize(CGSizeMake(self.iconSize, self.iconSize))
        self.userCommitmentIcon.image = FAKIonIcons.androidTimeIconWithSize(self.iconSize)
            .imageWithSize(CGSizeMake(self.iconSize, self.iconSize))
        
        self.userStatusIcon.sizeToFit()
        self.userCommitmentIcon.sizeToFit()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setHeight(self.boxHeight)
        
        self.topBorder.fillWidth()
        self.topBorder.setX(0)
        self.topBorder.setY(0)
        
        self.bottomBorder.fillWidth()
        self.bottomBorder.setX(0)
        self.bottomBorder.setY(self.boxHeight)
        
        self.timerView.transform = CGAffineTransformIdentity
        self.timerView.setX(0)
        self.timerView.centerVertically()
        self.timerView.transform = CGAffineTransformMakeRotation(-3*CGFloat(M_PI)/4)
        
        let progressViewX = CGRectGetWidth(self.bottomBorder.frame) - CGRectGetWidth(self.timerView.frame)
        self.progressContainer.setX(progressViewX)
        self.progressContainer.centerVertically()
        
        self.hoursPercentageLabel.sizeToFit()
        self.hoursPercentageLabel.centerInSuperview()
        
        self.userStatusLabel.setHeight(self.timerSize/2)
        self.userStatusLabel.fillWidth()
        self.userStatusLabel.setX(25)
        self.userStatusLabel.setY(0)
        
        self.userCommitmentLabel.setHeight(self.timerSize/2)
        self.userCommitmentLabel.fillWidth()
        self.userCommitmentLabel.setX(25)
        self.userCommitmentLabel.setY(CGRectGetMaxY(self.userStatusLabel.frame) - 8)
        
        self.userStatusIcon.setX(0)
        self.userStatusIcon.setY(8)
        self.userCommitmentIcon.setX(0)
        self.userCommitmentIcon.setY(CGRectGetMaxY(self.userStatusLabel.frame))
        
        self.userInformationContainer.setWidth(300)
        self.userInformationContainer.setHeight(60)
        self.userInformationContainer.setX(self.sideMargin)
        self.userInformationContainer.centerVertically()
    }
}
