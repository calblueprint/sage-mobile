//
//  CheckinRequestTableViewCell.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/14/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class CheckinRequestTableViewCell: UITableViewCell {

    var mentorPicture = UIImageView()
    var mentorName = UILabel()
    var time = UILabel()
    var content = UILabel()
    var checkButton = UIButton()
    var xButton = UIButton()
    
    struct DummyCellHolder {
        static var cell = CheckinRequestTableViewCell()
    }
    
    init() {
        super.init(style: .Default, reuseIdentifier: "CheckinRequestCell")
        self.contentView.addSubview(self.mentorPicture)
        self.contentView.addSubview(self.mentorName)
        self.contentView.addSubview(self.time)
        self.contentView.addSubview(self.content)
        self.contentView.addSubview(self.checkButton)
        self.contentView.addSubview(self.xButton)
        self.selectionStyle = .None
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithCheckin(checkin: Checkin) {
        let user = checkin.user!
        self.mentorPicture.setImageWithUser(user)
        self.mentorPicture.layer.cornerRadius = UIConstants.userImageSize/2
        self.mentorPicture.clipsToBounds = true
        
        let mentorText = user.firstName! + " " + user.lastName!
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 16
        let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName: UIFont.getDefaultFont(14)]
        self.mentorName.attributedText = NSAttributedString(string: mentorText, attributes:attributes)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        let fullDateText = " - " + dateFormatter.stringFromDate(checkin.startTime!)
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let flags = NSCalendarUnit.Hour
        let components = calendar!.components(flags, fromDate: checkin.startTime!, toDate: checkin.endTime!, options: [])

        var durationText = String(components.hour) + " hours"
        if components.hour == 1 {
            durationText = String(components.hour) + " hour"
        }
        
        let fullString = durationText + fullDateText
        let attributedString = NSMutableAttributedString(string: durationText + fullDateText)
        let dateRange = (fullString as NSString).rangeOfString(fullDateText)
        let durationRange = (fullString as NSString).rangeOfString(durationText)
        let fullRange = (fullString as NSString).rangeOfString(fullString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.getBoldFont(14), range: durationRange)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.secondaryTextColor, range: dateRange)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.getDefaultFont(14), range: dateRange)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: fullRange)
        time.attributedText = attributedString


        self.content.text = checkin.comment!
        
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

        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.mentorPicture.setHeight(UIConstants.userImageSize)
        self.mentorPicture.setWidth(UIConstants.userImageSize)
        self.mentorPicture.setX(UIConstants.sideMargin)
        self.mentorPicture.setY(UIConstants.verticalMargin)

        self.mentorName.font = UIFont.normalFont
        self.mentorName.textAlignment = NSTextAlignment.Left
        self.mentorName.sizeToFit()
        self.mentorName.setX(10 + CGRectGetMaxX(self.mentorPicture.frame))
        self.mentorName.setY(UIConstants.verticalMargin)
        
        self.time.textAlignment = NSTextAlignment.Left
        self.time.sizeToFit()
        self.time.setX(10 + CGRectGetMaxX(self.mentorPicture.frame))
        self.time.setY(CGRectGetMaxY(self.mentorName.frame))
        
        self.checkButton.setHeight(42)
        self.checkButton.setX(self.contentView.frame.width - UIConstants.sideMargin - 32)
        self.checkButton.setY(0)
        self.checkButton.setWidth(42)
        
        self.xButton.setHeight(42)
        self.xButton.setWidth(42)
        self.xButton.setX(self.contentView.frame.width - UIConstants.sideMargin - 32)
        self.xButton.setY(self.contentView.frame.height - 32 - UIConstants.verticalMargin)
        
        self.content.numberOfLines = 0
        self.content.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.content.font = UIFont.normalFont
        self.content.textAlignment = NSTextAlignment.Left
        self.content.setY(-5 + CGRectGetMaxY(self.time.frame))
        let contentX = 10 + CGRectGetMaxX(self.mentorPicture.frame)
        self.content.setX(contentX)
        self.content.fillWidthWithMargin(UIConstants.sideMargin)
        let width = CGRectGetMinX(self.xButton.frame) - contentX
        self.content.setSize(self.content.sizeThatFits(CGSizeMake(width, CGFloat.max)))
        
        self.setHeight(CGRectGetMaxY(self.content.frame)+UIConstants.textMargin)
    }
    
    static func heightForCheckinRequest(checkin: Checkin, width: CGFloat) -> CGFloat {
        let cell = CheckinRequestTableViewCell.DummyCellHolder.cell
        cell.setWidth(width)
        cell.configureWithCheckin(checkin)
        return CGRectGetHeight(cell.frame)
    }
    
    deinit {
        self.mentorPicture.cancelImageRequestOperation()
    }
    
    override func prepareForReuse() {
        self.mentorPicture.cancelImageRequestOperation()
    }

}
