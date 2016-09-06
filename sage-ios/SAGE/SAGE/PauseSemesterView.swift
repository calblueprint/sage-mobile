//
//  PauseSemesterView.swift
//  SAGE
//
//  Created by Andrew Millman on 7/6/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation
import FontAwesomeKit

class PauseSemesterView: UIView {
    
    let cancelIconButton = UIButton()
    let continueButton = SGButton()
    let cancelButton = SGButton()
    
    private let container = UIView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let announcementCell = AnnouncementsTableViewCell()
    
    private let buttonWidth: CGFloat = 150
    private let buttonHeight: CGFloat = 44
    
    //
    // MARK: - Initialization and Setup
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupSubviews() {
        
        self.addSubview(self.container)
        
        self.cancelIconButton.setWidth(UIConstants.barbuttonSize)
        self.cancelIconButton.setHeight(UIConstants.barbuttonSize)
        let cancelButtonIcon = FAKIonIcons.closeRoundIconWithSize(UIConstants.barbuttonIconSize)
        cancelButtonIcon.setAttributes([NSForegroundColorAttributeName: UIColor.blackColor()])
        let cancelIconButtonImage = cancelButtonIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        self.cancelIconButton.setImage(cancelIconButtonImage, forState: UIControlState.Normal)
        self.addSubview(self.cancelIconButton)
        
        self.titleLabel.font = UIFont.getTitleFont(40)
        self.titleLabel.text = "Pause Hours"
        self.titleLabel.textAlignment = .Center
        self.titleLabel.numberOfLines = 0
        self.container.addSubview(self.titleLabel)
        
        self.descriptionLabel.font = UIFont.getDefaultFont(20)
        self.descriptionLabel.text = "Pausing Hours means that students will not be required to mentor for the following week."
        self.descriptionLabel.textAlignment = .Center
        self.descriptionLabel.numberOfLines = 0
        self.container.addSubview(self.descriptionLabel)
        
        self.continueButton.setWidth(buttonWidth)
        self.continueButton.setHeight(buttonHeight)
        self.continueButton.setTitle("Proceed", forState: .Normal)
        self.continueButton.titleLabel!.font = UIFont.getSemiboldFont(17)
        self.continueButton.backgroundColor = UIColor.lightGreenColor
        self.continueButton.layer.cornerRadius = 5
        self.container.addSubview(self.continueButton)
        
        self.cancelButton.setWidth(buttonWidth)
        self.cancelButton.setHeight(buttonHeight)
        self.cancelButton.setTitle("Cancel", forState: .Normal)
        self.cancelButton.titleLabel!.font = UIFont.getSemiboldFont(17)
        self.cancelButton.setTitleColor(UIColor.grayTextColor, forState: .Normal)
        self.cancelButton.backgroundColor = UIColor.lighterGrayColor
        self.cancelButton.layer.cornerRadius = 5
        self.container.addSubview(self.cancelButton)
        
        self.announcementCell.alpha = 0
        self.container.addSubview(self.announcementCell)
    }
    
    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.container.fillWidth()
        
        self.cancelIconButton.setX(8)
        self.cancelIconButton.setY(UIConstants.statusBarHeight)
        
        self.resizeTitleAndDescription()
        self.descriptionLabel.centerHorizontally()
        self.descriptionLabel.setY(CGRectGetMaxY(self.titleLabel.frame) + UIConstants.verticalMargin)
        
        self.continueButton.centerHorizontally()
        self.continueButton.setY(CGRectGetMaxY(self.descriptionLabel.frame) + 100)
        
        self.cancelButton.setX(CGRectGetMinX(self.continueButton.frame))
        self.cancelButton.setY(CGRectGetMaxY(self.continueButton.frame) + UIConstants.verticalMargin)
        
        self.announcementCell.setX(UIConstants.sideMargin)
        self.announcementCell.fillWidthWithMargin(UIConstants.sideMargin)
        
        self.container.setHeight(CGRectGetMaxY(self.cancelButton.frame))
        self.container.centerVertically()
    }
    
    private func resizeTitleAndDescription() {
        self.titleLabel.sizeToFit()
        self.titleLabel.centerHorizontally()
        
        let descriptionWidth = UIConstants.screenWidth - 2*UIConstants.sideMargin
        let descriptionHeight = self.descriptionLabel.sizeThatFits(CGSizeMake(descriptionWidth, CGFloat.max)).height
        self.descriptionLabel.setSize(width: descriptionWidth, height: descriptionHeight)
    }
    
    //
    // MARK: - Public Methods
    //
    func showAnnouncementPrompt(completion completion: () -> Void) {
        self.continueButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        
        let outwardTranslation: CGFloat = UIConstants.screenHeight/2
        let inwardTranslation: CGFloat = outwardTranslation - 25
        
        UIView .animateWithDuration(UIConstants.normalAnimationTime, delay: 0, usingSpringWithDamping: UIConstants.defaultSpringDampening, initialSpringVelocity: UIConstants.defaultSpringVelocity, options: [], animations: { 
            self.titleLabel.moveY(-outwardTranslation)
            self.descriptionLabel.moveY(-outwardTranslation)
            self.continueButton.moveY(outwardTranslation)
            self.cancelButton.moveY(outwardTranslation)
            }) { (completed) in
                self.titleLabel.text = "Done!"
                self.descriptionLabel.text = "Now, create an announcement to let your mentors know"
                self.resizeTitleAndDescription()
                self.continueButton.backgroundColor = UIColor.mainColor
                self.continueButton.setTitle("Let's Do it!", forState: .Normal)
                
                self.announcementCell.layer.borderColor = UIColor.borderColor.CGColor
                self.announcementCell.layer.borderWidth = UIConstants.dividerHeight()
                self.announcementCell.layer.cornerRadius = 4
                self.announcementCell.alpha = 1
                self.announcementCell.setupWithAnnouncement(self.makeDummyAnnouncement())
                self.announcementCell.setY(CGRectGetMinY(self.titleLabel.frame))
                
                UIView .animateWithDuration(UIConstants.normalAnimationTime, delay: 0, usingSpringWithDamping: UIConstants.defaultSpringDampening, initialSpringVelocity: UIConstants.defaultSpringVelocity, options: [], animations: {
                    self.titleLabel.moveY(inwardTranslation)
                    self.descriptionLabel.moveY(inwardTranslation)
                    self.continueButton.moveY(-inwardTranslation)
                    self.cancelButton.moveY(-inwardTranslation)
                    let newAnnouncementCellY = (CGRectGetMaxY(self.descriptionLabel.frame)+CGRectGetMinY(self.continueButton.frame))/2
                    self.announcementCell.center = CGPointMake(self.container.center.x, newAnnouncementCellY)
                }) { (completed) in
                    completion()
                }
        }
    }
    
    //
    // MARK: - Private methods
    //
    private func makeDummyAnnouncement() -> Announcement {
        return Announcement(
            id: 0,
            sender: LoginOperations.getUser(),
            title: "Break Next Week",
            text: "Have a good break everybody!",
            timeCreated: NSDate(),
            school: nil
        )
    }
}
