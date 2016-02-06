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
    let profileUserImg = ProfileImageView()
    let profileUserImgBorder = UIView()
    let profileEditButton = UIButton()
    let promoteButton = SGButton()
    let demoteButton = SGButton()
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
    let userRoleLabel = UILabel()
    
    // profile page constants
    let viewHeight = CGFloat(351.5)
    let headerOffset = CGFloat(500)
    let leftMargin = CGFloat(30)
    let headerHeight = CGFloat(120)
    let titleFontSize = CGFloat(22)
    let profileImageSize = CGFloat(90)
    let profileImageBorder = CGFloat(6)
    let boxHeight = CGFloat(100)
    
    let userStatusString = "User Status String"
    let userCommitmentString = "User Commitment String"
    
    var currentUserProfile: Bool {
        get {
            return self.currentUserProfile
        }
        set(isCurrentUser) {
            if isCurrentUser {
                self.profileEditButton.hidden = false
            } else {
                self.profileEditButton.hidden = true
            }
        }
    }
    
    var showBothButtons = false
    
    var canPromote: Bool {
        get {
            return self.canPromote
        }
        set (promoteStatus) {
            if promoteStatus {
                self.promoteButton.hidden = false
            } else {
                self.promoteButton.hidden = true
            }
        }
    }
    
    var canDemote: Bool {
        get {
            return self.canDemote
        }
        set (demoteStatus) {
            if demoteStatus {
                self.demoteButton.hidden = false
            } else {
                self.demoteButton.hidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.profileContent)
        self.profileContent.addSubview(self.header)
        self.profileContent.addSubview(self.profileEditButton)
        self.profileContent.addSubview(self.promoteButton)
        self.profileContent.addSubview(self.demoteButton)
        self.profileContent.addSubview(self.profileUserImgBorder)
        self.profileContent.addSubview(self.profileUserImg)
        self.profileContent.addSubview(self.userName)
        self.profileContent.addSubview(self.userSchool)
        self.profileContent.addSubview(self.userRoleLabel)

        self.profileContent.addSubview(self.userVolunteerLevel)
        self.profileContent.addSubview(self.topBorder)
        self.profileContent.addSubview(self.bottomBorder)
        self.profileContent.addSubview(self.centerBorder)
        self.profileContent.addSubview(self.userStatusContainer)
        self.userStatusContainer.addSubview(self.userStatusLabel)
        self.profileContent.addSubview(self.userCommitmentContainer)
        self.userCommitmentContainer.addSubview(self.userCommitmentLabel)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustToScroll(offset: CGFloat) {
        if (offset > 0) {
            self.profileUserImg.alpha = 3/offset
            self.profileUserImgBorder.alpha = 3/offset
        }
    }
    
    func styleAttributedString(name: String, string: NSMutableAttributedString, length: Int) {
        let boldString = [NSFontAttributeName: UIFont.getSemiboldFont(30)]

        if name == self.userStatusString {
            string.addAttributes(boldString, range: NSRange(location: 0, length: length))
            let remainderLocation = string.length - 5
            string.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor, range: NSRange(location: remainderLocation, length: 5))
        }
        
        if name == self.userCommitmentString {
            string.addAttributes(boldString, range: NSRange(location: 0, length: length))
            string.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor, range: NSRange(location: 3, length: 10))
        }
    }
    
    func setupWithUser(user: User) {
        self.setButtonVisibility(user)
        
        self.profileUserImg.setImageWithUser(user)
        self.userName.text = user.fullName()
        self.userSchool.text = user.school?.name
        self.userVolunteerLevel.text = user.volunteerLevelToString(user.level)
        
        if let semesterSummary = user.semesterSummary {
            self.userStatusLabel.font = UIFont.normalFont
            let hoursCompletedString = String(semesterSummary.getTotalHours())
            let userStatusString = NSMutableAttributedString(string: hoursCompletedString + " / " + String(semesterSummary.hoursRequired) + " \nhours")
            styleAttributedString(self.userStatusString, string: userStatusString, length: hoursCompletedString.characters.count)
            self.userStatusLabel.attributedText = userStatusString
        } else {
            self.userStatusLabel.font = UIFont.normalFont
            self.userStatusLabel.text = "Inactive"
        }
        
        let weeklyHoursRequiredString = String(user.getRequiredHours())
        let userCommitmentString = NSMutableAttributedString(string: weeklyHoursRequiredString + " \nhours/week")
        styleAttributedString(self.userCommitmentString, string: userCommitmentString, length: weeklyHoursRequiredString.characters.count)
        self.userCommitmentLabel.attributedText = userCommitmentString
        
        var roleString = "Mentor"
        if user.role == .Admin {
            if user.isDirector() {
                roleString = "Director"
            } else {
                roleString = "Admin"
            }
        } else if user.role == .President {
            roleString = "President"
        } else if user.verified == false {
            roleString = "Unverified"
        }
        self.userRoleLabel.text = roleString
        
        layoutSubviews()
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        self.header.backgroundColor = UIColor.mainColor
        
        self.profileUserImgBorder.layer.cornerRadius = (self.profileImageSize + self.profileImageBorder)/2
        self.profileUserImgBorder.backgroundColor = UIColor.whiteColor()
        
        self.profileEditButton.setTitle("Edit Profile", forState: .Normal)
        self.profileEditButton.setTitleColor(UIColor.secondaryTextColor, forState: .Normal)
        self.profileEditButton.titleLabel?.font = UIFont.normalFont
        self.profileEditButton.titleLabel?.textColor = UIColor.secondaryTextColor
        self.profileEditButton.hidden = true
        
        self.promoteButton.setTitle("Promote", forState: .Normal)
        self.promoteButton.setThemeColor(UIColor.secondaryTextColor)
        self.promoteButton.layer.borderWidth = 1.0
        self.promoteButton.layer.borderColor = UIColor.secondaryTextColor.CGColor
        self.promoteButton.layer.cornerRadius = 3
        self.promoteButton.clipsToBounds = true
        self.promoteButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.promoteButton.hidden = true
        self.promoteButton.titleLabel?.font = UIFont.normalFont

        self.demoteButton.setTitle("Demote", forState: .Normal)
        self.demoteButton.setThemeColor(UIColor.lightRedColor)
        self.demoteButton.layer.borderWidth = 1.0
        self.demoteButton.layer.borderColor = UIColor.lightRedColor.CGColor
        self.demoteButton.layer.cornerRadius = 3
        self.demoteButton.clipsToBounds = true
        self.demoteButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.demoteButton.hidden = true
        self.demoteButton.titleLabel?.font = UIFont.normalFont

        
        self.profileUserImg.layer.cornerRadius = self.profileImageSize/2
        self.profileUserImg.clipsToBounds = true
        
        self.userName.font = UIFont.getSemiboldFont(20)
        self.userSchool.font = UIFont.normalFont
        self.userVolunteerLevel.font = UIFont.normalFont
        self.userRoleLabel.font = UIFont.normalFont
        
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

        self.profileContent.fillWidth()
        
        // set up header
        self.header.setY(-500)
        self.header.fillWidth()
        self.header.setHeight(self.headerHeight+self.headerOffset)
        
        // position edit button
        self.profileEditButton.layoutIfNeeded()
        self.profileEditButton.sizeToFit()
        self.profileEditButton.setY(self.headerHeight + 15)
        let profileEditButtonX = CGRectGetWidth(self.header.frame) - self.leftMargin - CGRectGetWidth(self.profileEditButton.frame)
        self.profileEditButton.setX(profileEditButtonX)
        
        // position promote button
        self.promoteButton.layoutIfNeeded()
        self.promoteButton.sizeToFit()
        self.promoteButton.setY(self.headerHeight + 15)
        let promoteEditButtonX = CGRectGetWidth(self.header.frame) - self.leftMargin - CGRectGetWidth(self.promoteButton.frame)
        self.promoteButton.setX(promoteEditButtonX)
        
        self.demoteButton.layoutIfNeeded()
        self.demoteButton.sizeToFit()
        self.demoteButton.setWidth(self.promoteButton.frame.width)
        let demoteEditButtonx = CGRectGetWidth(self.header.frame) - self.leftMargin - CGRectGetWidth(self.demoteButton.frame)
        self.demoteButton.setX(demoteEditButtonx)
        
        if self.showBothButtons {
            self.demoteButton.setY(CGRectGetMaxY(self.promoteButton.frame) + UIConstants.verticalMargin)
        } else {
            self.demoteButton.setY(self.headerHeight + 15)
        }
        

        // set up image
        self.profileUserImgBorder.setHeight(self.profileImageSize + self.profileImageBorder)
        self.profileUserImgBorder.setWidth(self.profileImageSize + self.profileImageBorder)
        self.profileUserImgBorder.setY(self.headerHeight/2)
        self.profileUserImgBorder.setX(self.leftMargin)
        
        self.profileUserImg.setDiameter(self.profileImageSize)
        let profileUserImgY = CGRectGetMinY(profileUserImgBorder.frame)
        let profileUserImgX = CGRectGetMinX(profileUserImgBorder.frame)
        self.profileUserImg.setY(profileUserImgY + self.profileImageBorder/2)
        self.profileUserImg.setX(profileUserImgX + self.profileImageBorder/2)
        
        // set up basic user information
        self.userName.fillWidth()
        self.userName.setHeight(20)
        self.userName.setX(self.leftMargin)
        let userNameY = CGRectGetMaxY(profileUserImg.frame) + 20
        self.userName.setY(userNameY)
        
        self.userSchool.fillWidth()
        self.userSchool.setHeight(12)
        self.userSchool.setX(self.leftMargin)
        let userSchoolY = CGRectGetMaxY(userName.frame) + 7
        self.userSchool.setY(userSchoolY)
        
        self.userVolunteerLevel.fillWidth()
        self.userVolunteerLevel.setHeight(12)
        self.userVolunteerLevel.setX(self.leftMargin)
        let userVolunteerLevelY = CGRectGetMaxY(userSchool.frame) + 7
        self.userVolunteerLevel.setY(userVolunteerLevelY)
        
        self.userRoleLabel.fillWidth()
        self.userRoleLabel.setHeight(12)
        self.userRoleLabel.setX(self.leftMargin)
        let userRoleLabelY = CGRectGetMaxY(userVolunteerLevel.frame) + 7
        self.userRoleLabel.setY(userRoleLabelY)
        
        // set up lines
        self.topBorder.setHeight(UIConstants.dividerHeight())
        self.topBorder.fillWidth()
        self.topBorder.setX(0)
        let topBorderY = CGRectGetMaxY(userRoleLabel.frame) + 20
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
        
        let height = CGRectGetMaxY(self.bottomBorder.frame)
        self.profileContent.setHeight(height)
        self.setHeight(height)
    }
    
    func setButtonVisibility(user: User) {
        self.showBothButtons = false
        if LoginOperations.getUser()?.id == user.id {
            self.currentUserProfile = true
        } else {
            self.currentUserProfile = false
        }
        self.canPromote = false
        self.canDemote = false
        let loggedInUser = LoginOperations.getUser()!
        if loggedInUser.role == .President && loggedInUser.id != user.id {
            self.canPromote = true
            if user.role == .Admin {
                self.canDemote = true
                self.showBothButtons = true
            }
        }
        self.layoutSubviews()
    }
    
    deinit {
        self.profileUserImg.cancelImageRequestOperation()
    }
    
    func startPromoting() {
        self.promoteButton.startLoading()
    }
    
    func startDemoting() {
        self.demoteButton.startLoading()
    }    
}