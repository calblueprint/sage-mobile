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
    let profileUserImgBorder = UIImageView()
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
        self.addSubview(self.topBorder)
        self.addSubview(self.bottomBorder)
        self.addSubview(self.centerBorder)
        self.addSubview(self.userStatusContainer)
        self.userStatusContainer.addSubview(self.userStatusLabel)
        self.addSubview(self.userCommitmentContainer)
        self.userCommitmentContainer.addSubview(self.userCommitmentLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithUser(user: User) {
        userName.text = user.firstName! + " " + user.lastName!
        userSchool.text = user.school?.name
        userVolunteerLevel.text = user.volunteerLevelToString(user.level)
        
        let boldString = [NSFontAttributeName: UIFont.getSemiboldFont(30)]
        
        let hoursCompleted = user.totalHours
        let userStatusString = NSMutableAttributedString(string: String(hoursCompleted) + " / 60 \nhours")
        userStatusString.addAttributes(boldString, range: NSRange(location: 0, length: 2))
        userStatusString.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor, range: NSRange(location: 8, length: 6))
        userStatusLabel.attributedText = userStatusString
        userStatusLabel.sizeToFit()
        userStatusLabel.centerInSuperview()
        
        let weeklyHoursRequired = 2 // ask charles about this
        let userCommitmentString = NSMutableAttributedString(string: String(weeklyHoursRequired) + " \nhours/week")
        userCommitmentString.addAttributes(boldString, range: NSRange(location: 0, length: 2))
        userCommitmentString.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor, range: NSRange(location: 3, length: 10))
        userCommitmentLabel.attributedText = userCommitmentString
        userCommitmentLabel.sizeToFit()
        userCommitmentLabel.centerInSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileContent.setHeight(400)
        profileContent.fillWidth()
        
        // set up header
        header.setHeight(120)
        header.fillWidth()
        header.backgroundColor = UIColor.mainColor
        
        // position edit button
        profileEditButton.text = "Edit Profile"
        profileEditButton.font = UIFont.normalFont
        profileEditButton.textColor = UIColor.secondaryTextColor
        profileEditButton.setWidth(200)
        profileEditButton.setHeight(14)
        profileEditButton.setX(270)
        profileEditButton.setY(135)
        
        // set up image
        profileUserImgBorder.setHeight(96)
        profileUserImgBorder.setWidth(96)
        profileUserImgBorder.setY(60)
        profileUserImgBorder.setX(25)
        profileUserImgBorder.layer.cornerRadius = 96/2
        profileUserImgBorder.backgroundColor = UIColor.whiteColor()
        
        let image = UIImage(named: "UserImage.jpg")
        profileUserImg.image = image
        profileUserImg.setHeight(90)
        profileUserImg.setWidth(90)
        profileUserImg.setY(63)
        profileUserImg.setX(28)
        profileUserImg.layer.cornerRadius = 90/2
        profileUserImg.clipsToBounds = true
        
        // set up basic user information
        userName.font = UIFont.getSemiboldFont(20)
        userName.fillWidth()
        userName.setHeight(22)
        userName.setX(30)
        userName.setY(170)
        
        userSchool.font = UIFont.normalFont
        userSchool.fillWidth()
        userSchool.setHeight(18)
        userSchool.setX(30)
        userSchool.setY(200)
        
        userVolunteerLevel.font = UIFont.normalFont
        userVolunteerLevel.fillWidth()
        userVolunteerLevel.setHeight(18)
        userVolunteerLevel.setX(30)
        userVolunteerLevel.setY(218)
        
        // set up lines
        topBorder.setHeight(UIConstants.dividerHeight())
        topBorder.fillWidth()
        topBorder.backgroundColor = UIColor.borderColor
        topBorder.setX(0)
        topBorder.setY(260)
        
        bottomBorder.setHeight(UIConstants.dividerHeight())
        bottomBorder.fillWidth()
        bottomBorder.backgroundColor = UIColor.borderColor
        bottomBorder.setX(0)
        bottomBorder.setY(360)
        
        centerBorder.setHeight(100)
        centerBorder.setWidth(UIConstants.dividerHeight())
        centerBorder.backgroundColor = UIColor.borderColor
        let middle = CGRectGetWidth(topBorder.frame)/2
        centerBorder.setX(middle)
        centerBorder.setY(260)
        
        // set up stats containers
        userStatusContainer.setX(0)
        userStatusContainer.setY(261)
        userStatusContainer.setHeight(99)
        userStatusContainer.setWidth(middle)
        
        userStatusLabel.font = UIFont.normalFont
        userStatusLabel.numberOfLines = 0
        userStatusLabel.textAlignment = NSTextAlignment.Center
        
        userCommitmentContainer.setX(middle+1)
        userCommitmentContainer.setY(261)
        userCommitmentContainer.setWidth(middle)
        userCommitmentContainer.setHeight(99)
        
        userCommitmentLabel.font = UIFont.normalFont
        userCommitmentLabel.numberOfLines = 0
        userCommitmentLabel.textAlignment = NSTextAlignment.Center
    }
    
    
}