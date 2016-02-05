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

class CheckinRequestTableViewCell: UITableViewCell {

    var mentorPicture = UIImageView()
    var mentorName = UILabel()
    var time = UILabel()
    var content = UILabel()
    var checkButton = UIButton()
    var xButton = UIButton()
    
    var checkinID: Int?
        
    struct DummyCellHolder {
        static var cell = CheckinRequestTableViewCell()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.checkinID = checkin.id
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
        dateFormatter.dateFormat = "MMMM d"
        let fullDateText = " - " + dateFormatter.stringFromDate(checkin.startTime!)
        
        let durationText = checkin.getDisplayText()
        
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

        self.content.text = checkin.comment
        
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
        
        self.checkButton.setHeight(buttonSize + buttonInset + buttonInset)
        self.checkButton.setX(self.contentView.frame.width - UIConstants.sideMargin - buttonSize - buttonInset)
        self.checkButton.centerVertically()
        self.checkButton.setWidth(buttonSize + buttonInset + buttonInset)
        
        self.xButton.setHeight(buttonSize + buttonInset + buttonInset)
        self.xButton.setWidth(buttonSize + buttonInset + buttonInset)
        self.xButton.setX(CGRectGetMinX(self.checkButton.frame) - buttonSize - buttonInset - buttonInset)
        self.xButton.centerVertically()
        
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
        
        if self.content.text == "" || self.content.text == nil {
            self.setHeight(CGRectGetMaxY(self.time.frame)-UIConstants.textMargin)
        } else {
            self.setHeight(CGRectGetMaxY(self.content.frame)+UIConstants.textMargin)
        }

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
