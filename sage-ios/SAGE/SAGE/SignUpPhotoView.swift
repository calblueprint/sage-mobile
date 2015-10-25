//
//  SignUpPhotoView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpPhotoView: SignUpFormView {
    var photoButton: UIButton = UIButton()
    var photoLabel: UILabel = UILabel()
    var skipAndFinishLink: UIButton = UIButton()
    var finishButton: UIButton = UIButton()
    var takePhotoButton: UIButton = UIButton()
    var takePhotoBorder: UIView = UIView()
    
    var photo: UIImageView = UIImageView()
    
    override func setUpViews() {
        super.setUpViews()
        self.containerView.addSubview(self.photoButton)
        self.containerView.addSubview(self.skipAndFinishLink)
        self.containerView.addSubview(self.finishButton)
        self.containerView.addSubview(self.photoLabel)
        self.containerView.addSubview(self.takePhotoButton)
        self.containerView.addSubview(self.photo)
        self.containerView.addSubview(self.takePhotoBorder)
        
        self.photoButton.layer.cornerRadius = 5
        self.photoButton.clipsToBounds = true
        self.photoButton.backgroundColor = UIColor.whiteColor()
        self.photoButton.alpha = 0.3
        
        self.finishButton.hidden = true
        self.finishButton.setTitle("Finish", forState: .Normal)
        self.finishButton.titleLabel!.font = UIFont.normalFont
        self.finishButton.hidden = true

        self.takePhotoButton.layer.cornerRadius = 35
        self.takePhotoButton.clipsToBounds = true
        self.takePhotoButton.backgroundColor = UIColor.whiteColor()
        self.takePhotoButton.alpha = 0.3
        
        self.photo.layer.cornerRadius = 35
        self.photo.clipsToBounds = true
        self.photo.contentMode = .ScaleAspectFill
        self.photo.userInteractionEnabled = false
        
        self.takePhotoBorder.layer.cornerRadius = 35
        self.takePhotoBorder.clipsToBounds = true
        self.takePhotoBorder.layer.borderWidth = 3
        self.takePhotoBorder.layer.borderColor = UIColor.whiteColor().CGColor
        self.takePhotoBorder.userInteractionEnabled = false
        
        self.photoLabel.text = "Add photo"
        self.photoLabel.textColor = UIColor.whiteColor()
        self.photoLabel.textAlignment = .Center
        self.photoLabel.font = UIFont.titleFont
        
        self.headerLabel.text = "One last step!"
        
        self.subHeaderLabel.text = "Let's put a face to you!"
        
        self.skipAndFinishLink.setTitle("Skip and Finish", forState: .Normal)
        self.skipAndFinishLink.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.skipAndFinishLink.titleLabel?.font = UIFont.normalFont
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        
        self.takePhotoButton.setWidth(70)
        self.takePhotoButton.setHeight(70)
        self.takePhotoButton.centerHorizontally()
        self.takePhotoButton.setY(160)
        
        self.photo.setWidth(70)
        self.photo.setHeight(70)
        self.photo.centerHorizontally()
        self.photo.setY(160)
        
        self.takePhotoBorder.setWidth(70)
        self.takePhotoBorder.setHeight(70)
        self.takePhotoBorder.centerHorizontally()
        self.takePhotoBorder.setY(160)
        
        self.photoButton.setX((screenWidth - 180)/2)
        self.photoButton.setWidth(180)
        self.photoButton.setY(285)
        self.photoButton.setHeight(44)
        
        self.photoLabel.setX(self.photoButton.frame.origin.x)
        self.photoLabel.setY(self.photoButton.frame.origin.y)
        self.photoLabel.setWidth(self.photoButton.frame.width)
        self.photoLabel.setHeight(self.photoButton.frame.height)
        
        self.finishButton.setX((screenWidth - 180)/2)
        self.finishButton.setWidth(180)
        self.finishButton.setY(screenRect.size.height - 129)
        self.finishButton.setHeight(44)
        
        self.skipAndFinishLink.sizeToFit()
        self.skipAndFinishLink.setY(CGRectGetMaxY(self.photoButton.frame) + 10)
        self.skipAndFinishLink.centerHorizontally()
    }
}
