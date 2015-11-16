//
//  BrowseMentorsTableViewCell.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseMentorsTableViewCell: UITableViewCell {
    
    var mentorPicture = UIImageView()
    var mentorName = UILabel()
    var schoolName = UILabel()
    var totalHours = UILabel()
    
    init() {
        super.init(style: .Default, reuseIdentifier: "BrowseCell")
    }
    
    func configureWithUser(user: User) {
        self.mentorPicture.setImageWithURL(user.imageURL!)
        self.mentorName.text = user.firstName! + " " + user.lastName!
        self.schoolName.text = user.school!.name
        self.totalHours.text = String(user.totalHours) + " hours"
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
        
        self.contentView.addSubview(self.mentorPicture)
        self.mentorPicture.setHeight(UIConstants.userImageSize)
        self.mentorPicture.setWidth(UIConstants.userImageSize)
        self.mentorPicture.setX(UIConstants.sideMargin)
        self.mentorPicture.setY(UIConstants.verticalMargin)
        self.mentorPicture.layer.cornerRadius = UIConstants.userImageSize/2
        self.mentorPicture.clipsToBounds = true
        
        self.contentView.addSubview(self.totalHours)
        self.totalHours.sizeToFit()
        self.totalHours.centerVertically()
        self.totalHours.setX(self.frame.width - self.totalHours.frame.width - UIConstants.sideMargin)
        self.totalHours.textColor = UIColor.secondaryTextColor
        self.totalHours.font = UIFont.getDefaultFont(16)
        
        self.contentView.addSubview(self.mentorName)
        self.mentorName.sizeToFit()
        self.mentorName.setY(UIConstants.verticalMargin)
        self.mentorName.setX(57)
        self.mentorName.setWidth(CGRectGetMinX(self.totalHours.frame) - 57.0 - UIConstants.textMargin)
        self.mentorName.font = UIFont.getSemiboldFont(16)
        
        self.contentView.addSubview(self.schoolName)
        self.schoolName.sizeToFit()
        self.schoolName.setY(CGRectGetMaxY(self.mentorName.frame)-5)
        self.schoolName.setX(57)
        self.mentorName.setWidth(CGRectGetMinX(self.totalHours.frame) - 57.0 - UIConstants.textMargin)
        self.schoolName.font = UIFont.getDefaultFont(14)
        self.schoolName.textColor = UIColor.secondaryTextColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
