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
    let userCheckinSummary = ProfileCheckinSummaryView()
    let userRoleLabel = UILabel()
    let userDangerButton = UIButton()
    
    // profile page constants
    let viewHeight = CGFloat(355)
    let headerOffset = CGFloat(500)
    let leftMargin = CGFloat(30)
    let headerHeight = CGFloat(120)
    let titleFontSize = CGFloat(22)
    let profileImageSize = CGFloat(90)
    let profileImageBorder = CGFloat(6)
    
    let userStatusString = "User Status String"
    let userCommitmentString = "User Commitment String"
    
    var currentUserProfile: Bool {
        get {
            return self.currentUserProfile
        }
        set (isCurrentUser) {
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
        self.profileContent.addSubview(self.userDangerButton)

        self.profileContent.addSubview(self.userVolunteerLevel)
        self.profileContent.addSubview(self.userCheckinSummary)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustToScroll(offset: CGFloat) {
        let alpha = 1 - offset/50
        self.profileUserImg.alpha = alpha
        self.profileUserImgBorder.alpha = alpha
    }
    
    func setupWithUser(user: User, pastSemester: Bool = false) {
        self.setButtonVisibility(user, pastSemester: pastSemester)
        
        self.profileUserImg.setImageWithUser(user, showBadge: false)
        self.userName.text = user.fullName()
        self.userSchool.text = user.school?.name
        self.userVolunteerLevel.text = user.volunteerLevelToString(user.level)
        self.userCheckinSummary.setupWithUser(user, pastSemester: pastSemester)
        
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
        self.userRoleLabel.backgroundColor = user.roleColor(preventInactive: true)
        
        if user.semesterSummary?.status == .Inactive {
            self.userDangerButton.hidden = false
        }
        
        layoutSubviews()
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        
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
        
        self.userRoleLabel.font = UIFont.getBoldFont(14)
        self.userRoleLabel.textAlignment = .Center
        self.userRoleLabel.textColor = UIColor.whiteColor()
        self.userRoleLabel.clipsToBounds = true
        self.userRoleLabel.layer.cornerRadius = 2
        
        self.userDangerButton.titleLabel?.font = UIFont.getBoldFont(14)
        self.userDangerButton.setTitle("!", forState: .Normal)
        self.userDangerButton.backgroundColor = UIColor.lightRedColor
        self.userDangerButton.setSize(width: 20, height: 20)
        self.userDangerButton.clipsToBounds = true
        self.userDangerButton.layer.cornerRadius = 10
        self.userDangerButton.hidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.profileContent.fillWidth()
        
        // set up header
        self.header.setY(-self.headerOffset)
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
        self.profileUserImgBorder.setY(self.headerHeight - (self.profileImageSize + self.profileImageBorder)/2)
        self.profileUserImgBorder.setX(self.leftMargin)
        
        self.profileUserImg.setDiameter(self.profileImageSize)
        let profileUserImgY = CGRectGetMinY(profileUserImgBorder.frame)
        let profileUserImgX = CGRectGetMinX(profileUserImgBorder.frame)
        self.profileUserImg.setY(profileUserImgY + self.profileImageBorder/2)
        self.profileUserImg.setX(profileUserImgX + self.profileImageBorder/2)
        
        // set up basic user information
        self.userName.sizeToFit()
        self.userName.fillWidthWithMargin(self.leftMargin)
        self.userName.setX(self.leftMargin)
        let userNameY = CGRectGetMaxY(profileUserImgBorder.frame) + UIConstants.verticalMargin
        self.userName.setY(userNameY)
        
        self.userSchool.fillWidth()
        self.userSchool.sizeToFit()
        self.userSchool.setX(self.leftMargin)
        let userSchoolY = CGRectGetMaxY(userName.frame) + UIConstants.verticalMargin
        self.userSchool.setY(userSchoolY)
        
        self.userVolunteerLevel.fillWidth()
        self.userVolunteerLevel.sizeToFit()
        self.userVolunteerLevel.setX(self.leftMargin)
        let userVolunteerLevelY = CGRectGetMaxY(userSchool.frame) + 3
        self.userVolunteerLevel.setY(userVolunteerLevelY)
        
        self.userRoleLabel.sizeToFit()
        self.userRoleLabel.increaseWidth(8)
        self.userRoleLabel.increaseHeight(4)
        self.userRoleLabel.setX(self.leftMargin - 4)
        let userRoleLabelY = CGRectGetMaxY(userVolunteerLevel.frame) + 3
        self.userRoleLabel.setY(userRoleLabelY)
        
        self.userDangerButton.setX(CGRectGetMaxX(self.userRoleLabel.frame) + UIConstants.textMargin)
        self.userDangerButton.center.y = self.userRoleLabel.center.y
        
        let topBorderY = CGRectGetMaxY(userRoleLabel.frame) + 20
        self.userCheckinSummary.setY(topBorderY)
        self.userCheckinSummary.setHeight(self.userCheckinSummary.boxHeight)
        self.userCheckinSummary.fillWidth()
        
        let height = CGRectGetMaxY(self.userCheckinSummary.frame)
        self.profileContent.setHeight(height)
        self.setHeight(height)
    }
    
    func setButtonVisibility(user: User, pastSemester: Bool = false) {
        self.showBothButtons = false
        if SAGEState.currentUser()?.id == user.id {
            self.currentUserProfile = true
        } else {
            self.currentUserProfile = false
        }
        self.canPromote = false
        self.canDemote = false
        let loggedInUser = SAGEState.currentUser()!
        if loggedInUser.role == .President && loggedInUser.id != user.id {
            self.canPromote = true
            if user.role == .Admin {
                self.canDemote = true
                self.showBothButtons = true
            }
        }
        if pastSemester {
            self.currentUserProfile = false
            self.canPromote = false
            self.canDemote = false
        }
        self.layoutSubviews()
    }
    
    deinit {
        self.profileUserImg.cancelImageRequestOperation()
    }
    
    func setHeaderBackgroundColor(color: UIColor) {
        self.header.backgroundColor = color
    }
    
    func startPromoting() {
        self.promoteButton.startLoading()
    }
    
    func startDemoting() {
        self.demoteButton.startLoading()
    }    
}
