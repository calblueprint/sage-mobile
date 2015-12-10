//
//  ProfileView.swift
//  SAGE
//
//  Created by Erica Yin on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class ProfileView: UIView {
    
    let profileContent = UIView()
    let header = UIView()
    let profileUserImg = UIImageView()
    let profileUserImgBorder = UIView()
    let profileEditButton = UILabel()
    let userName = UILabel()
    let userVolunteerLevel = UILabel()
    let userSchool = UILabel()
    let topBorder = UIView()
    let bottomBorder = UIView()
    let centerBorder = UIView()
    let userStatusContainer = UIView()
    let userStatusLabel = UILabel()
    let userCommitmentContainer = UIView()
    let userCommitmentLabel = UILabel()
    
    // profile page constants
    let viewHeight = CGFloat(351.5)
    let headerOffset = CGFloat(500)
    let leftMargin = CGFloat(30)
    let headerHeight = CGFloat(120)
    let titleFontSize = CGFloat(22)
    let profileImageSize = CGFloat(90)
    let profileImageBorder = CGFloat(6)
    let boxHeight = CGFloat(100)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.profileContent)
        self.profileContent.addSubview(self.header)
        self.profileContent.addSubview(self.profileEditButton)
        self.profileContent.addSubview(self.profileUserImgBorder)
        self.profileContent.addSubview(self.profileUserImg)
        self.profileContent.addSubview(self.userName)
        self.profileContent.addSubview(self.userSchool)
        self.profileContent.addSubview(self.userVolunteerLevel)
        self.profileContent.addSubview(self.topBorder)
        self.profileContent.addSubview(self.bottomBorder)
        self.profileContent.addSubview(self.centerBorder)
        self.profileContent.addSubview(self.userStatusContainer)
        self.userStatusContainer.addSubview(self.userStatusLabel)
        self.profileContent.addSubview(self.userCommitmentContainer)
        self.userCommitmentContainer.addSubview(self.userCommitmentLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleAttributedString(name: String, string: NSMutableAttributedString) {
        let boldString = [NSFontAttributeName: UIFont.getSemiboldFont(30)]

        if name == "userStatusString" {
            string.addAttributes(boldString, range: NSRange(location: 0, length: 2))
            string.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor, range: NSRange(location: 8, length: 6))
        }
        
        if name == "userCommitmentString" {
            string.addAttributes(boldString, range: NSRange(location: 0, length: 2))
            string.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor, range: NSRange(location: 3, length: 10))
        }
    }
    
    func setupWithUser(user: User) {
        self.profileUserImg.setImageWithUser(user)
        self.userName.text = user.fullName()
        self.userSchool.text = user.school?.name
        self.userVolunteerLevel.text = user.volunteerLevelToString(user.level)
        
        let hoursCompleted = user.totalHours
        let userStatusString = NSMutableAttributedString(string: String(hoursCompleted) + " / 60 \nhours") // ask charles about the 60
        styleAttributedString("userStatusString", string: userStatusString)
        self.userStatusLabel.attributedText = userStatusString
        self.userStatusLabel.sizeToFit()
        self.userStatusLabel.centerInSuperview()
        
        let weeklyHoursRequired = user.getRequiredHours()
        let userCommitmentString = NSMutableAttributedString(string: String(weeklyHoursRequired) + " \nhours/week")
        styleAttributedString("userCommitmentString", string: userCommitmentString)
        self.userCommitmentLabel.attributedText = userCommitmentString
        self.userCommitmentLabel.sizeToFit()
        self.userCommitmentLabel.centerInSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.whiteColor()
        self.profileContent.fillWidth()
        
        // set up header
        self.header.setY(-500)
        self.header.setHeight(self.headerHeight+self.headerOffset)
        self.header.fillWidth()
        self.header.backgroundColor = UIColor.mainColor
        
        // position edit button
        self.profileEditButton.text = "Edit Profile"
        self.profileEditButton.font = UIFont.normalFont
        self.profileEditButton.textColor = UIColor.secondaryTextColor
        self.profileEditButton.sizeToFit()
        let profileEditButtonX = CGRectGetWidth(self.header.frame) - self.leftMargin - CGRectGetWidth(self.profileEditButton.frame)
        self.profileEditButton.setX(profileEditButtonX)
        self.profileEditButton.setY(self.headerHeight + 15)
        
        // set up image
        self.profileUserImgBorder.setHeight(self.profileImageSize + self.profileImageBorder)
        self.profileUserImgBorder.setWidth(self.profileImageSize + self.profileImageBorder)
        self.profileUserImgBorder.setY(self.headerHeight/2)
        self.profileUserImgBorder.setX(self.leftMargin)
        self.profileUserImgBorder.layer.cornerRadius = (self.profileImageSize + self.profileImageBorder)/2
        self.profileUserImgBorder.backgroundColor = UIColor.whiteColor()
        
        self.profileUserImg.setHeight(self.profileImageSize)
        self.profileUserImg.setWidth(self.profileImageSize)
        let profileUserImgY = CGRectGetMinY(profileUserImgBorder.frame)
        let profileUserImgX = CGRectGetMinX(profileUserImgBorder.frame)
        self.profileUserImg.setY(profileUserImgY + self.profileImageBorder/2)
        self.profileUserImg.setX(profileUserImgX + self.profileImageBorder/2)
        self.profileUserImg.layer.cornerRadius = self.profileImageSize/2
        self.profileUserImg.clipsToBounds = true
        
        // set up basic user information
        self.userName.font = UIFont.getSemiboldFont(20)
        self.userName.fillWidth()
        self.userName.setHeight(20)
        self.userName.setX(self.leftMargin)
        let userNameY = CGRectGetMaxY(profileUserImg.frame) + 20
        self.userName.setY(userNameY)
        
        self.userSchool.font = UIFont.normalFont
        self.userSchool.fillWidth()
        self.userSchool.setHeight(12)
        self.userSchool.setX(self.leftMargin)
        let userSchoolY = CGRectGetMaxY(userName.frame) + 7
        self.userSchool.setY(userSchoolY)
        
        self.userVolunteerLevel.font = UIFont.normalFont
        self.userVolunteerLevel.fillWidth()
        self.userVolunteerLevel.setHeight(12)
        self.userVolunteerLevel.setX(self.leftMargin)
        let userVolunteerLevelY = CGRectGetMaxY(userSchool.frame) + 7
        self.userVolunteerLevel.setY(userVolunteerLevelY)
        
        // set up lines
        self.topBorder.setHeight(UIConstants.dividerHeight())
        self.topBorder.fillWidth()
        self.topBorder.backgroundColor = UIColor.borderColor
        self.topBorder.setX(0)
        let topBorderY = CGRectGetMaxY(userVolunteerLevel.frame) + 20
        self.topBorder.setY(topBorderY)
        
        self.bottomBorder.setHeight(UIConstants.dividerHeight())
        self.bottomBorder.fillWidth()
        self.bottomBorder.backgroundColor = UIColor.borderColor
        self.bottomBorder.setX(0)
        self.bottomBorder.setY(topBorderY + self.boxHeight)
        
        self.centerBorder.setHeight(self.boxHeight)
        self.centerBorder.setWidth(UIConstants.dividerHeight())
        self.centerBorder.backgroundColor = UIColor.borderColor
        let middle = CGRectGetWidth(topBorder.frame)/2
        self.centerBorder.setX(middle)
        self.centerBorder.setY(topBorderY)
        
        // set up stats containers
        self.userStatusContainer.setX(0)
        self.userStatusContainer.setY(topBorderY+1)
        self.userStatusContainer.setHeight(self.boxHeight-1)
        self.userStatusContainer.setWidth(middle)
        
        self.userStatusLabel.font = UIFont.normalFont
        self.userStatusLabel.numberOfLines = 0
        self.userStatusLabel.textAlignment = NSTextAlignment.Center
        
        self.userCommitmentContainer.setX(middle+1)
        self.userCommitmentContainer.setY(topBorderY+1)
        self.userCommitmentContainer.setWidth(middle)
        self.userCommitmentContainer.setHeight(self.boxHeight-1)
        
        self.userCommitmentLabel.font = UIFont.normalFont
        self.userCommitmentLabel.numberOfLines = 0
        self.userCommitmentLabel.textAlignment = NSTextAlignment.Center
        
        let height = CGRectGetMaxY(self.bottomBorder.frame)
        self.profileContent.setHeight(height)
        self.setHeight(height)
    }
    
    deinit {
        self.profileUserImg.cancelImageRequestOperation()
    }
    
}