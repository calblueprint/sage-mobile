//
//  UsersTableViewCell.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    var mentorPicture = ProfileImageView()
    var mentorName = UILabel()
    var schoolName = UILabel()
    var totalHours = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle  = .None
        self.setUpSubviews()
    }
    
    func setUpSubviews() {
        self.contentView.addSubview(self.mentorPicture)
        
        self.contentView.addSubview(self.totalHours)
        self.totalHours.textColor = UIColor.secondaryTextColor
        self.totalHours.font = UIFont.getDefaultFont(14)
        
        self.contentView.addSubview(self.mentorName)
        self.mentorName.font = UIFont.semiboldFont
        
        self.contentView.addSubview(self.schoolName)
        self.schoolName.font = UIFont.getDefaultFont(14)
        self.schoolName.textColor = UIColor.secondaryTextColor

    }
    
    func configureWithUser(user: User) {
        self.mentorPicture.setImageWithUser(user)
        self.mentorName.text = user.fullName()
        self.schoolName.text = user.school?.name
        if let semesterSummary = user.semesterSummary {
            self.totalHours.text = String(semesterSummary.getTotalHoursAsString())
            self.totalHours.text! += " hour"
            if semesterSummary.getTotalHours() != 1 {
                self.totalHours.text! += "s"
            }
        } else {
            self.totalHours.text = "Inactive"
        }
    }
    
    static func cellHeight() -> CGFloat {
        return 52.0
    }
    
    deinit {
        self.mentorPicture.cancelImageRequestOperation()
    }
    
    override func prepareForReuse() {
        self.mentorPicture.cancelImageRequestOperation()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.mentorPicture.setDiameter(UIConstants.userImageSize)
        self.mentorPicture.setX(UIConstants.sideMargin)
        self.mentorPicture.setY(UIConstants.verticalMargin)
        
        self.totalHours.sizeToFit()
        self.totalHours.centerVertically()
        self.totalHours.setX(self.frame.width - self.totalHours.frame.width - UIConstants.sideMargin)
        self.totalHours.frame = CGRectIntegral(self.totalHours.frame)
        
        let mentorSchoolX = CGRectGetMaxX(self.mentorPicture.frame) + UIConstants.textMargin;
        
        self.mentorName.sizeToFit()
        self.mentorName.setY(UIConstants.verticalMargin)
        self.mentorName.setX(mentorSchoolX)
        self.mentorName.setWidth(CGRectGetMinX(self.totalHours.frame) - mentorSchoolX - UIConstants.textMargin)
        
        self.schoolName.sizeToFit()
        self.schoolName.setY(CGRectGetMaxY(self.mentorName.frame))
        self.schoolName.setX(mentorSchoolX)
        self.schoolName.setWidth(CGRectGetMinX(self.totalHours.frame) - mentorSchoolX - UIConstants.textMargin)
        
        if self.schoolName.text == nil {
            self.mentorName.centerVertically()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
