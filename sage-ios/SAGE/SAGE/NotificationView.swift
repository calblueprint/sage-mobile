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

    static let notificationHeight = UIConstants.navbarHeight
    private let imageViewHeight: CGFloat = 32

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

        self.contentContainer.setHeight(NotificationView.notificationHeight)
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
        self.contentContainer.addSubview(self.divider)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentContainer.fillWidth()
        self.contentContainer.fillHeight()

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

        self.divider.setY(CGRectGetMaxY(self.contentContainer.frame) - CGRectGetHeight(self.divider.frame))
        self.divider.fillWidth()
    }



    func showNotification(title title: String, subtitle: String, image: UIImage?) {

        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.imageView.image = image
        self.layoutSubviews()

        self.setY(-NotificationView.notificationHeight)
        self.hideStatusBar()
        UIView.animateWithDuration(UIConstants.normalAnimationTime,  delay: 0, usingSpringWithDamping: UIConstants.defaultSpringDampening, initialSpringVelocity: UIConstants.defaultSpringVelocity*2, options: [], animations: { () -> Void in
            self.moveY(NotificationView.notificationHeight)
            }) { (finished) -> Void in
                if finished {
                    let delay: NSTimeInterval = 4
                    self.performSelector(#selector(NotificationView.showStatusBar), withObject: nil, afterDelay: delay)
                    UIView.animateWithDuration(UIConstants.fastAnimationTime, delay: delay, options: .CurveEaseOut, animations: { () -> Void in
                        self.moveY(-NotificationView.notificationHeight)
                        }) { (finished) -> Void in
                    }
                }
        }
    }

    @objc private func hideStatusBar() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
    }

    @objc private func showStatusBar() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
    }
}
