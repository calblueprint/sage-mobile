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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        profileUserImgBorder.layer.cornerRadius = 90/2
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
        userName.text = "Kelsey Lam"
        userName.font = UIFont.getSemiboldFont(20)
        userName.fillWidth()
        userName.setHeight(22)
        userName.setX(30)
        userName.setY(170)
        
        userSchool.text = "Berkeley High School"
        userSchool.font = UIFont.normalFont
        userSchool.fillWidth()
        userSchool.setHeight(18)
        userSchool.setX(30)
        userSchool.setY(200)
        
        userVolunteerLevel.text = "1 Unit Volunteer"
        userVolunteerLevel.font = UIFont.normalFont
        userVolunteerLevel.fillWidth()
        userVolunteerLevel.setHeight(18)
        userVolunteerLevel.setX(30)
        userVolunteerLevel.setY(218)
        
        // set up lines
        topBorder.setHeight(1)
        topBorder.fillWidth()
        topBorder.backgroundColor = UIColor.borderColor
        topBorder.setX(0)
        topBorder.setY(260)
        
        bottomBorder.setHeight(1)
        bottomBorder.fillWidth()
        bottomBorder.backgroundColor = UIColor.borderColor
        bottomBorder.setX(0)
        bottomBorder.setY(360)
        
        centerBorder.setHeight(100)
        centerBorder.setWidth(1)
        centerBorder.backgroundColor = UIColor.borderColor
        let middle = CGRectGetWidth(topBorder.frame)/2
        centerBorder.setX(middle)
        centerBorder.setY(260)
        
        
    
    }
    
    
}