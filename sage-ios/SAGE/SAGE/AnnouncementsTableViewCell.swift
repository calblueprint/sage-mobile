//
//  AnnouncementsTableViewCell.swift
//  SAGE
//
//  Created by Erica Yin on 10/17/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import UIKit

class AnnouncementsTableViewCell: UITableViewCell {
    let announcementUserImg = UIImageView()
    var announcementUserName = UILabel()
    var announcementTitle = UILabel()
    var announcementTime = UILabel()
    var announcementMessage = UILabel()
    
    struct DummyCellHolder {
        static var cell = AnnouncementsTableViewCell()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(announcementUserImg)
        contentView.addSubview(announcementUserName)
        contentView.addSubview(announcementTime)
        contentView.addSubview(announcementTitle)
        contentView.addSubview(announcementMessage)
        self.selectionStyle = .None
        setUpCellStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func heightForAnnouncement(announcement: Announcement, width: CGFloat) -> CGFloat {
        let cell = AnnouncementsTableViewCell.DummyCellHolder.cell
        cell.setWidth(width)
        cell.setupWithAnnouncement(announcement)
        return CGRectGetHeight(cell.frame)
    }
    
    func setupWithAnnouncement(announcement: Announcement) {
        let image = UIImage(named: "UserImage.jpg")
        self.announcementUserImg.image = image
        self.announcementTitle.text = announcement.title
        self.announcementMessage.text = announcement.text
        
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let date1 = calendar.startOfDayForDate(announcement.timeCreated!)
        let date2 = calendar.startOfDayForDate(NSDate())
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
        let days = components.day
        if days == 0 {
            self.announcementTime.text = "Today"
        } else {
            self.announcementTime.text = String(days) + " days ago"
        }
        
        var announcementTo = "Everyone"
        if (announcement.school != nil) {
            announcementTo = (announcement.school?.name)!
        }
        let boldString = [NSFontAttributeName: UIFont.getSemiboldFont(14.0)]
        let nameLength = (announcement.sender?.firstName)!.characters.count + (announcement.sender?.lastName)!.characters.count + 1
        let toIndex = nameLength + 4
        let toLength = announcementTo.characters.count
        let announcementString = NSMutableAttributedString(string: (announcement.sender?.firstName)! + " " + (announcement.sender?.lastName)! + " to " + announcementTo)
        announcementString.addAttributes(boldString, range: NSRange(location: 0, length: nameLength))
        announcementString.addAttributes(boldString, range: NSRange(location: toIndex, length: toLength))
        self.announcementUserName.attributedText = announcementString
        layoutSubviews()
    }
    
    func setUpCellStyle() {
        announcementUserImg.setHeight(UIConstants.userImageSize)
        announcementUserImg.setWidth(UIConstants.userImageSize)
        
        announcementUserName.font = UIFont.normalFont
        announcementUserName.textAlignment = NSTextAlignment.Left
        
        announcementTime.textColor = UIColor.secondaryTextColor
        announcementTime.font = UIFont.normalFont
        announcementTime.textAlignment = NSTextAlignment.Left
        
        announcementTitle.font = UIFont.boldSystemFontOfSize(14)
        announcementTitle.textAlignment = NSTextAlignment.Left
        
        announcementMessage.numberOfLines = 4
        announcementMessage.lineBreakMode = .ByTruncatingTail
        announcementMessage.font = UIFont.normalFont
        announcementMessage.textAlignment = NSTextAlignment.Left
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        announcementUserImg.layer.cornerRadius = UIConstants.userImageSize/2
        announcementUserImg.clipsToBounds = true
        announcementUserImg.setX(UIConstants.sideMargin)
        announcementUserImg.setY(UIConstants.textMargin)
        
        let announcementUserImgRight = CGRectGetMaxX(announcementUserImg.frame)
        announcementUserName.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementUserName.setY(UIConstants.textMargin)
        announcementUserName.setHeight(16)
        announcementUserName.fillWidthWithMargin(UIConstants.sideMargin)
        
        let announcementTimeY = CGRectGetMaxY(announcementUserName.frame)
        announcementTime.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementTime.setY(announcementTimeY)
        announcementTime.setHeight(16)
        announcementTime.fillWidthWithMargin(UIConstants.sideMargin)
        
        let announcementTitleY = CGRectGetMaxY(announcementTime.frame) + UIConstants.textMargin
        announcementTitle.setY(announcementTitleY)
        announcementTitle.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementTitle.setHeight(16)
        announcementTitle.fillWidthWithMargin(UIConstants.sideMargin)
        
        let announcementMessageY = CGRectGetMaxY(announcementTitle.frame) + UIConstants.textMargin
        announcementMessage.setY(announcementMessageY)
        announcementMessage.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementMessage.setHeight(10)
        announcementMessage.fillWidthWithMargin(UIConstants.sideMargin)
        let width = CGRectGetWidth(announcementMessage.frame)
        announcementMessage.setSize(announcementMessage.sizeThatFits(CGSizeMake(width, CGFloat.max)))
        
        self.setHeight(CGRectGetMaxY(announcementMessage.frame)+UIConstants.textMargin)
    }
}
