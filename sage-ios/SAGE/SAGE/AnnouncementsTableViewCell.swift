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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(announcementUserImg)
        contentView.addSubview(announcementUserName)
        contentView.addSubview(announcementTime)
        contentView.addSubview(announcementTitle)
        contentView.addSubview(announcementMessage)
        setUpCellStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCellStyle() {
        announcementUserImg.backgroundColor = UIColor.borderColor
        announcementUserImg.setHeight(32)
        announcementUserImg.setWidth(32)
        
        announcementUserName.font = UIFont(name: "Arial", size: 14)
        announcementUserName.textAlignment = NSTextAlignment.Left
        announcementUserName.text = "John Doe"
        
        announcementTime.textColor = UIColor.secondaryTextColor
        announcementTime.font = UIFont(name: "Arial", size: 14)
        announcementTime.textAlignment = NSTextAlignment.Left
        announcementTime.text = "5 days ago"
        
        announcementTitle.font = UIFont.boldSystemFontOfSize(14)
        announcementTitle.textAlignment = NSTextAlignment.Left
        announcementTitle.text = "Announcement Title"
        
        announcementMessage.numberOfLines = 0
        announcementMessage.lineBreakMode = NSLineBreakMode.ByWordWrapping
        announcementMessage.font = UIFont(name: "Arial", size: 14)
        announcementMessage.textAlignment = NSTextAlignment.Left
        announcementMessage.text = "text here hello goodbye i like to eat but i really just need to sleep overflow nom nom nom nom nom nom nom nom nom nom fml i just realized that i'm not done with this yet"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        announcementUserImg.layer.cornerRadius = 16
        announcementUserImg.setX(UIConstants.sideMargin)
        announcementUserImg.setY(UIConstants.textMargin)
        
        var announcementUserImgRight = CGRectGetMaxX(announcementUserImg.frame)
        announcementUserName.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementUserName.setY(10)
        announcementUserName.setHeight(16)
        announcementUserName.fillWidthWithMargin(15)
        
        var announcementTimeY = CGRectGetMaxY(announcementUserName.frame)
        announcementTime.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementTime.setY(announcementTimeY)
        announcementTime.setHeight(16)
        announcementTime.fillWidthWithMargin(15)
        
        var announcementTitleY = CGRectGetMaxY(announcementTime.frame) + UIConstants.textMargin
        announcementTitle.setY(announcementTitleY)
        announcementTitle.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementTitle.setHeight(16)
        announcementTitle.fillWidthWithMargin(15)
        
        var announcementMessageY = CGRectGetMaxY(announcementTitle.frame) + UIConstants.textMargin
        announcementMessage.setY(announcementMessageY)
        announcementMessage.setX(announcementUserImgRight+UIConstants.textMargin)
        announcementMessage.setHeight(40)
        announcementMessage.fillWidthWithMargin(15)
        let width = CGRectGetWidth(announcementMessage.frame)
        announcementMessage.setSize(announcementMessage.sizeThatFits(CGSizeMake(width, CGFloat.max)))
    }
}
