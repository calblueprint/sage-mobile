//
//  CheckinRequestTableViewCell.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/14/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpRequestTableViewCell: UITableViewCell {
    
    var userPicture = UIImageView()
    var userName = UILabel()
    var schoolAndHours = UILabel()
    var checkButton = UIButton()
    var xButton = UIButton()
    
    var userID: Int?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.userPicture)
        self.contentView.addSubview(self.userName)
        self.contentView.addSubview(self.schoolAndHours)
        self.contentView.addSubview(self.checkButton)
        self.contentView.addSubview(self.xButton)
        self.selectionStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithUser(user: User) {
        self.userID = user.id
        self.userPicture.setImageWithUser(user)
        self.userPicture.layer.cornerRadius = UIConstants.userImageSize/2
        self.userPicture.clipsToBounds = true
        
        let mentorText = user.firstName! + " " + user.lastName!
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 16
        let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName: UIFont.getDefaultFont(14)]
        self.userName.attributedText = NSAttributedString(string: mentorText, attributes:attributes)
        
        var hoursText = ""
        if user.level == User.VolunteerLevel.ZeroUnit {
            hoursText = "Zero Units"
        } else if user.level == User.VolunteerLevel.OneUnit {
            hoursText = "One Unit"
        } else {
            hoursText = "Two Units"
        }
        self.schoolAndHours.text = user.school!.name! + " - " + hoursText
        self.schoolAndHours.font = UIFont.normalFont
        
        let checkIcon = FAKIonIcons.androidDoneIconWithSize(22)
        checkIcon.setAttributes([NSForegroundColorAttributeName: UIColor.lightGreenColor])
        let checkImage = checkIcon.imageWithSize(CGSizeMake(22, 22))
        self.checkButton.setImage(checkImage, forState: .Normal)
        self.checkButton.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        self.checkButton.imageView!.contentMode = .Center;
        
        let xIcon = FAKIonIcons.androidCloseIconWithSize(22)
        xIcon.setAttributes([NSForegroundColorAttributeName: UIColor.lightRedColor])
        let xImage = xIcon.imageWithSize(CGSizeMake(22, 22))
        self.xButton.setImage(xImage, forState: .Normal)
        self.xButton.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        self.xButton.imageView!.contentMode = .Center;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.userPicture.setHeight(UIConstants.userImageSize)
        self.userPicture.setWidth(UIConstants.userImageSize)
        self.userPicture.setX(UIConstants.sideMargin)
        self.userPicture.setY(UIConstants.verticalMargin)
        
        self.userName.font = UIFont.getSemiboldFont(14)
        self.userName.textAlignment = NSTextAlignment.Left
        self.userName.sizeToFit()
        self.userName.setX(10 + CGRectGetMaxX(self.userPicture.frame))
        self.userName.setY(UIConstants.verticalMargin)
        
        self.schoolAndHours.textAlignment = NSTextAlignment.Left
        self.schoolAndHours.sizeToFit()
        self.schoolAndHours.setX(10 + CGRectGetMaxX(self.userPicture.frame))
        self.schoolAndHours.setY(CGRectGetMaxY(self.userName.frame))
        
        self.checkButton.setHeight(42)
        self.checkButton.setX(self.contentView.frame.width - UIConstants.sideMargin - 32)
        self.checkButton.centerVertically()
        self.checkButton.setWidth(42)
        
        self.xButton.setHeight(42)
        self.xButton.setWidth(42)
        self.xButton.setX(CGRectGetMinX(self.checkButton.frame)-42)
        self.xButton.centerVertically()
    }
    
    deinit {
        self.userPicture.cancelImageRequestOperation()
    }
    
    override func prepareForReuse() {
        self.userPicture.cancelImageRequestOperation()
    }
    
    static func cellHeight() -> CGFloat {
        return 52.0
    }
    
}
