//
//  AnnouncementsDetailView.swift
//  SAGE
//
//  Created by Erica Yin on 11/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class AnnouncementsDetailView: UIView {
    var tableView = UITableView()
    let announcementUserImg = UIImageView()
    var announcementUserName = UILabel()
    var announcementTitle = UILabel()
    var announcementTime = UILabel()
    var announcementMessage = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView.tableFooterView = UIView()
        self.addSubview(announcementUserImg)
        self.addSubview(announcementUserName)
        self.addSubview(announcementTime)
        self.addSubview(announcementTitle)
        self.addSubview(announcementMessage)
        setUpViewStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func formatDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        return dateFormatter.stringFromDate(date)
    }
    
    func setupWithAnnouncement(announcement: Announcement) {
        self.announcementTitle.text = announcement.title
        self.announcementMessage.text = announcement.text
        self.announcementTime.text = self.formatDate((announcement.timeCreated)!)
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
    
    
    func setUpViewStyle() {
        announcementUserImg.backgroundColor = UIColor.borderColor
        announcementUserImg.setHeight(32)
        announcementUserImg.setWidth(32)
        
        announcementUserName.font = UIFont(name: "Arial", size: 14)
        announcementUserName.textAlignment = NSTextAlignment.Left
        
        announcementTime.textColor = UIColor.secondaryTextColor
        announcementTime.font = UIFont(name: "Arial", size: 14)
        announcementTime.textAlignment = NSTextAlignment.Left
        
        announcementTitle.font = UIFont.boldSystemFontOfSize(14)
        announcementTitle.textAlignment = NSTextAlignment.Left
        
        announcementMessage.numberOfLines = 0
        announcementMessage.lineBreakMode = NSLineBreakMode.ByWordWrapping
        announcementMessage.font = UIFont(name: "Arial", size: 14)
        announcementMessage.textAlignment = NSTextAlignment.Left
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        announcementUserImg.layer.cornerRadius = 16
        announcementUserImg.setX(UIConstants.sideMargin)
        announcementUserImg.setY(UIConstants.textMargin)
        
        let announcementUserImgRight = CGRectGetMaxX(announcementUserImg.frame)
        announcementUserName.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementUserName.setY(10)
        announcementUserName.setHeight(16)
        announcementUserName.fillWidthWithMargin(15)
        
        let announcementTimeY = CGRectGetMaxY(announcementUserName.frame)
        announcementTime.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementTime.setY(announcementTimeY)
        announcementTime.setHeight(16)
        announcementTime.fillWidthWithMargin(15)
        
        let announcementTitleY = CGRectGetMaxY(announcementTime.frame) + UIConstants.textMargin
        announcementTitle.setY(announcementTitleY)
        announcementTitle.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementTitle.setHeight(16)
        announcementTitle.fillWidthWithMargin(15)
        
        let announcementMessageY = CGRectGetMaxY(announcementTitle.frame) + UIConstants.textMargin
        announcementMessage.setY(announcementMessageY)
        announcementMessage.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementMessage.setHeight(40)
        announcementMessage.fillWidthWithMargin(15)
        let width = CGRectGetWidth(announcementMessage.frame)
        announcementMessage.setSize(announcementMessage.sizeThatFits(CGSizeMake(width, CGFloat.max)))
    }
}