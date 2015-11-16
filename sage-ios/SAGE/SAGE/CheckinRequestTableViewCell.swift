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
        self.mentorPicture.setImageWithURL(user.imageURL!)
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
        checkIcon.setAttributes([NSForegroundColorAttributeName: UIColor.greenColor()])
        let checkImage = checkIcon.imageWithSize(CGSizeMake(22, 22))
        self.checkButton.imageView?.image = checkImage
        
        let xIcon = FAKIonIcons.androidCancelIconWithSize(22)
        xIcon.setAttributes([NSForegroundColorAttributeName: UIColor.redColor()])
        let xImage = xIcon.imageWithSize(CGSizeMake(22, 22))
        self.xButton.imageView?.image = xImage
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.mentorPicture.setHeight(UIConstants.userImageSize)
        self.mentorPicture.setWidth(UIConstants.userImageSize)
        self.mentorPicture.setX(UIConstants.sideMargin)
        self.mentorPicture.setY(0)

        self.mentorName.font = UIFont.normalFont
        self.mentorName.textAlignment = NSTextAlignment.Left
        mentorName.sizeToFit()
        self.setY(UIConstants.textMargin)
        self.mentorName.setX(10 + CGRectGetMaxX(self.mentorPicture.frame))
        
        self.time.textAlignment = NSTextAlignment.Left
        self.time.sizeToFit()
        self.time.setX(10 + CGRectGetMaxX(self.mentorPicture.frame))
        self.time.setY(CGRectGetMaxY(self.mentorName.frame))
        
        self.content.numberOfLines = 0
        self.content.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.content.font = UIFont.normalFont
        self.content.textAlignment = NSTextAlignment.Left
        self.content.setY(-5 + CGRectGetMaxY(self.time.frame))
        self.content.setX(10 + CGRectGetMaxX(self.mentorPicture.frame))
        self.content.fillWidthWithMargin(UIConstants.sideMargin)
        let width = CGRectGetWidth(self.content.frame)
        self.content.setSize(self.content.sizeThatFits(CGSizeMake(width, CGFloat.max)))
        
        self.checkButton.setHeight(22)
        self.checkButton.setX(CGRectGetMaxX(self.content.frame) - UIConstants.textMargin - 15 - 22)
        self.checkButton.setY(UIConstants.verticalMargin)
        self.checkButton.setWidth(22)
        
        self.xButton.setHeight(22)
        self.xButton.setWidth(22)
        
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
