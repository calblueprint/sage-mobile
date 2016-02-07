//
//  CheckinTableViewCell.swift
//  SAGE
//
//  Created by Erica Yin on 12/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

import UIKit

class CheckinTableViewCell: UITableViewCell {
    
    var userPicture = ProfileImageView()
    var userName = UILabel()
    var time = UILabel()
    
    var checkinID = -1
    
    struct DummyCellHolder {
        static var cell = CheckinTableViewCell()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.userPicture)
        self.contentView.addSubview(self.userName)
        self.contentView.addSubview(self.time)
        self.selectionStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithCheckin(checkin: Checkin) {
        self.checkinID = checkin.id
        let user = checkin.user!
        self.userPicture.setImageWithUser(user)
        
        let userText = user.firstName! + " " + user.lastName!
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 16
        let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName: UIFont.getDefaultFont(14)]
        self.userName.attributedText = NSAttributedString(string: userText, attributes:attributes)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        let fullDateText = " - " + dateFormatter.stringFromDate(checkin.startTime!)
        
        let durationText = checkin.getDurationText()
        
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
        
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.userPicture.setDiameter(UIConstants.userImageSize)
        self.userPicture.setX(UIConstants.sideMargin)
        self.userPicture.setY(UIConstants.verticalMargin)
        
        self.userName.font = UIFont.normalFont
        self.userName.textAlignment = NSTextAlignment.Left
        self.userName.sizeToFit()
        self.userName.setX(10 + CGRectGetMaxX(self.userPicture.frame))
        self.userName.setY(UIConstants.verticalMargin)
        
        self.time.textAlignment = NSTextAlignment.Left
        self.time.sizeToFit()
        self.time.setX(10 + CGRectGetMaxX(self.userPicture.frame))
        self.time.setY(CGRectGetMaxY(self.userName.frame))
        self.setHeight(CGRectGetMaxY(self.time.frame)-UIConstants.textMargin)
    }
    
    static func heightForCheckinRequest(checkin: Checkin, width: CGFloat) -> CGFloat {
        let cell = CheckinTableViewCell.DummyCellHolder.cell
        cell.setWidth(width)
        cell.configureWithCheckin(checkin)
        return CGRectGetHeight(cell.frame)
    }
    
    deinit {
        self.userPicture.cancelImageRequestOperation()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userPicture.cancelImageRequestOperation()
    }
    
}
