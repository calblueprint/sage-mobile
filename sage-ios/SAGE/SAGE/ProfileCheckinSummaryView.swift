//
//  ProfileCheckinSummaryView.swift
//  SAGE
//
//  Created by Erica Yin on 3/12/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class ProfileCheckinSummaryView: UIView {
    
    let topBorder = UIView()
    let bottomBorder = UIView()
    let centerBorder = UIView()
    let userStatusContainer = UIView()
    let userStatusLabel = UILabel()
    let userCommitmentContainer = UIView()
    let userCommitmentLabel = UILabel()
    let leftMargin = CGFloat(30)
    let titleFontSize = CGFloat(22)
    let boxHeight = CGFloat(100)
    
    let userStatusString = "User Status String"
    let userCommitmentString = "User Commitment String"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.topBorder)
        self.addSubview(self.bottomBorder)
        self.addSubview(self.centerBorder)
        self.addSubview(self.userStatusContainer)
        self.userStatusContainer.addSubview(self.userStatusLabel)
        self.addSubview(self.userCommitmentContainer)
        self.userCommitmentContainer.addSubview(self.userCommitmentLabel)
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
            let userStatusString = NSMutableAttributedString(string: hoursCompletedString + " / " + String(semesterSummary.hoursRequired) + " \nhours")
            var userHoursStringColor = UIColor.blackColor()
            if pastSemester {
                if semesterSummary.completed {
                    userHoursStringColor = UIColor.lightGreenColor
                } else {
                    userHoursStringColor = UIColor.lightRedColor
                }
            }
            styleAttributedString(self.userStatusString, string: userStatusString, length: hoursCompletedString.characters.count, userHoursStringColor: userHoursStringColor)
            self.userStatusLabel.attributedText = userStatusString
        } else {
            self.userStatusLabel.font = UIFont.normalFont
            self.userStatusLabel.text = "Inactive"
        }
        
        let weeklyHoursRequiredString = String(user.getRequiredHours())
        let userCommitmentString = NSMutableAttributedString(string: weeklyHoursRequiredString + " \nhours/week")
        styleAttributedString(self.userCommitmentString, string: userCommitmentString, length: weeklyHoursRequiredString.characters.count)
        self.userCommitmentLabel.attributedText = userCommitmentString
        
        layoutSubviews()
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        
        self.topBorder.backgroundColor = UIColor.borderColor
        self.bottomBorder.backgroundColor = UIColor.borderColor
        self.centerBorder.backgroundColor = UIColor.borderColor
        
        self.userStatusLabel.font = UIFont.normalFont
        self.userStatusLabel.numberOfLines = 0
        self.userStatusLabel.textAlignment = .Center
        
        self.userCommitmentLabel.font = UIFont.normalFont
        self.userCommitmentLabel.numberOfLines = 0
        self.userCommitmentLabel.textAlignment = .Center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.topBorder.setHeight(UIConstants.dividerHeight())
        self.topBorder.fillWidth()
        self.topBorder.setX(0)
        let topBorderY = CGFloat(0)
        self.topBorder.setY(topBorderY)
        
        self.bottomBorder.setHeight(UIConstants.dividerHeight())
        self.bottomBorder.fillWidth()
        self.bottomBorder.setX(0)
        self.bottomBorder.setY(topBorderY + self.boxHeight)
        
        self.centerBorder.setHeight(self.boxHeight)
        self.centerBorder.setWidth(UIConstants.dividerHeight())
        let middle = CGRectGetWidth(topBorder.frame)/2
        self.centerBorder.setX(middle)
        self.centerBorder.setY(topBorderY)
        
        // set up stats containers
        self.userStatusContainer.setX(0)
        self.userStatusContainer.setY(topBorderY+1)
        self.userStatusContainer.setHeight(self.boxHeight-1)
        self.userStatusContainer.setWidth(middle)
        
        self.userCommitmentContainer.setX(middle+1)
        self.userCommitmentContainer.setY(topBorderY+1)
        self.userCommitmentContainer.setWidth(middle)
        self.userCommitmentContainer.setHeight(self.boxHeight-1)
        
        self.userCommitmentLabel.sizeToFit()
        self.userCommitmentLabel.centerInSuperview()
        
        self.userStatusLabel.sizeToFit()
        self.userStatusLabel.centerInSuperview()
    }
}
