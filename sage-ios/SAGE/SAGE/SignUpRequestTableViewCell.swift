//
//  CheckinRequestTableViewCell.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/14/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

private let buttonSize: CGFloat = 22.0
private let buttonInset: CGFloat = 10.0

class SignUpRequestTableViewCell: UITableViewCell {
    
    var userPicture = ProfileImageView()
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
        
        if let name = user.school?.name {
            self.schoolAndHours.text = name + " - " + hoursText
        } else {
            self.schoolAndHours.text = hoursText            
        }
        self.schoolAndHours.font = UIFont.normalFont
        
        let checkIcon = FAKIonIcons.androidDoneIconWithSize(buttonSize)
        checkIcon.setAttributes([NSForegroundColorAttributeName: UIColor.lightGreenColor])
        let checkImage = checkIcon.imageWithSize(CGSizeMake(buttonSize, buttonSize))
        self.checkButton.setImage(checkImage, forState: .Normal)
        self.checkButton.imageEdgeInsets = UIEdgeInsets(top: -buttonInset, left: -buttonInset, bottom: -buttonInset, right: -buttonInset)
        self.checkButton.imageView!.contentMode = .Center;
        
        let xIcon = FAKIonIcons.androidCloseIconWithSize(buttonSize)
        xIcon.setAttributes([NSForegroundColorAttributeName: UIColor.lightRedColor])
        let xImage = xIcon.imageWithSize(CGSizeMake(buttonSize, buttonSize))
        self.xButton.setImage(xImage, forState: .Normal)
        self.xButton.imageEdgeInsets = UIEdgeInsets(top: -buttonInset, left: -buttonInset, bottom: -buttonInset, right: -buttonInset)
        self.xButton.imageView!.contentMode = .Center;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.userPicture.setDiameter(UIConstants.userImageSize)
        self.userPicture.setX(UIConstants.sideMargin)
        self.userPicture.setY(UIConstants.verticalMargin)
        
        self.userName.font = UIFont.getSemiboldFont(14)
        self.userName.textAlignment = NSTextAlignment.Left
        self.userName.sizeToFit()
        self.userName.setX(10 + CGRectGetMaxX(self.userPicture.frame))
        self.userName.setY(UIConstants.verticalMargin)
        
        self.checkButton.setHeight(buttonSize + buttonInset + buttonInset)
        self.checkButton.setX(self.contentView.frame.width - UIConstants.sideMargin - buttonSize - buttonInset)
        self.checkButton.centerVertically()
        self.checkButton.setWidth(buttonSize + buttonInset + buttonInset)
        
        self.xButton.setHeight(buttonSize + buttonInset + buttonInset)
        self.xButton.setWidth(buttonSize + buttonInset + buttonInset)
        self.xButton.setX(CGRectGetMinX(self.checkButton.frame) - buttonSize - buttonInset - buttonInset)
        self.xButton.centerVertically()
        
        self.schoolAndHours.textAlignment = NSTextAlignment.Left
        self.schoolAndHours.sizeToFit()
        self.schoolAndHours.setX(10 + CGRectGetMaxX(self.userPicture.frame))
        self.schoolAndHours.setY(CGRectGetMaxY(self.userName.frame))
        self.schoolAndHours.setWidth(self.xButton.frame.origin.x - self.schoolAndHours.frame.origin.x)
    
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
