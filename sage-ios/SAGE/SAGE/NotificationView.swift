//
//  NotificationView.swift
//  SAGE
//
//  Created by Andrew Millman on 5/3/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class NotificationView: UIView {

    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    private let divider = UIView()

    static let notificationHeight = UIConstants.navbarHeight + 10
    private let imageViewHeight = UIConstants.bareNavbarHeight - 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        self.setY(-NotificationView.notificationHeight)
        self.setHeight(NotificationView.notificationHeight)

        self.contentContainer.setY(UIConstants.statusBarHeight)
        self.contentContainer.setHeight(UIConstants.bareNavbarHeight)
        self.addSubview(self.contentContainer)

        self.titleLabel.font = UIFont.semiboldFont
        self.contentContainer.addSubview(self.titleLabel)

        self.subtitleLabel.font = UIFont.normalFont
        self.contentContainer.addSubview(self.subtitleLabel)

        self.imageView.setWidth(imageViewHeight)
        self.imageView.setHeight(imageViewHeight)
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.layer.cornerRadius = imageViewHeight/2
        self.imageView.clipsToBounds = true
        self.contentContainer.addSubview(self.imageView)

        self.divider.setHeight(UIConstants.dividerHeight())
        self.divider.backgroundColor = UIColor.borderColor
        self.addSubview(self.divider)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentContainer.fillWidth()
        self.contentContainer.fillHeightWithMargin(3)

        self.imageView.setX(UIConstants.sideMargin)
        self.imageView.centerVertically()

        if let _ = self.imageView.image {
            self.titleLabel.setX(CGRectGetMaxX(self.imageView.frame) + UIConstants.textMargin)
        } else {
            self.titleLabel.setX(UIConstants.sideMargin)
        }
        self.titleLabel.sizeToFit()
        self.titleLabel.fillWidthWithMargin(UIConstants.sideMargin)
        self.titleLabel.alignBottomWithMargin(CGRectGetHeight(self.titleLabel.superview!.frame)/2)

        self.subtitleLabel.setX(CGRectGetMinX(self.titleLabel.frame))
        self.subtitleLabel.sizeToFit()
        self.subtitleLabel.fillWidthWithMargin(UIConstants.sideMargin)
        self.subtitleLabel.setY(CGRectGetMaxY(self.titleLabel.frame))

        self.divider.setY(CGRectGetMaxY(self.frame) - CGRectGetHeight(self.divider.frame))
        self.divider.fillWidth()
    }



    func showNotification(title title: String, subtitle: String, image: UIImage?) {

        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.imageView.image = image
        self.layoutSubviews()

        self.setY(-NotificationView.notificationHeight)
        UIApplication.sharedApplication().statusBarStyle = .Default
        UIView.animateWithDuration(UIConstants.normalAnimationTime,  delay: 0, usingSpringWithDamping: UIConstants.defaultSpringDampening, initialSpringVelocity: UIConstants.defaultSpringVelocity*2, options: [], animations: { () -> Void in
            self.moveY(NotificationView.notificationHeight)
            }) { (finished) -> Void in
                if finished {
                    UIView.animateWithDuration(UIConstants.fastAnimationTime, delay: 4, options: .CurveEaseIn, animations: { () -> Void in
                        self.moveY(-NotificationView.notificationHeight)
                        }) { (finished) -> Void in
                            // If in session mode, keep black
                            if let _ = KeychainWrapper.stringForKey(KeychainConstants.kSessionStartTime) {
                                UIApplication.sharedApplication().statusBarStyle = .Default
                            } else {
                                UIApplication.sharedApplication().statusBarStyle = .LightContent
                            }
                    }
                }
        }
    }
}
