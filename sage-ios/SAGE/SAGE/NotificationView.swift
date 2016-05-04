//
//  NotificationView.swift
//  SAGE
//
//  Created by Andrew Millman on 5/3/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class NotificationView: UIView {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()

    static let notificationHeight = UIConstants.navbarHeight
    private let imageViewHeight = notificationHeight - 2*UIConstants.verticalMargin

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

        self.titleLabel.font = UIFont.semiboldFont
        self.addSubview(self.titleLabel)

        self.subtitleLabel.font = UIFont.normalFont
        self.addSubview(self.subtitleLabel)

        self.imageView.setWidth(imageViewHeight)
        self.imageView.setHeight(imageViewHeight)
        self.imageView.layer.cornerRadius = imageViewHeight/2
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView.setX(UIConstants.sideMargin)
        self.imageView.centerVertically()

        if let _ = self.imageView.image {
            self.titleLabel.setX(CGRectGetMaxX(self.imageView.frame) + UIConstants.sideMargin)
        } else {
            self.titleLabel.setX(UIConstants.sideMargin)
        }
        self.titleLabel.sizeToFit()
        self.titleLabel.fillWidthWithMargin(UIConstants.sideMargin)
        self.titleLabel.alignBottomWithMargin(CGRectGetHeight(self.frame)/2)

        self.subtitleLabel.setX(CGRectGetMinX(self.titleLabel.frame))
        self.subtitleLabel.sizeToFit()
        self.subtitleLabel.fillWidthWithMargin(UIConstants.sideMargin)
        self.subtitleLabel.setY(CGRectGetHeight(self.frame)/2)
    }



    func showNotification(title title: String, subtitle: String, image: UIImage?) {
        let animationTime = 0.10

        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.imageView.image = image
        self.layoutSubviews()

        UIView.animateWithDuration(animationTime,  delay: 0, options: .CurveLinear, animations: { () -> Void in
            self.moveY(NotificationView.notificationHeight)
            }) { (finished) -> Void in
                if finished {
                    UIView.animateWithDuration(animationTime, delay: 4, options: .CurveLinear, animations: { () -> Void in
                        self.moveY(-NotificationView.notificationHeight)
                        }, completion: nil)
                }
        }
    }
}
