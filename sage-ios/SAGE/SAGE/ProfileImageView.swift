//
//  ProfileImageView.swift
//  SAGE
//
//  Created by Andrew Millman on 2/5/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class ProfileImageView: UIView {

    private var imageView = UIImageView()
    private var badgeBorder = UIView()
    private var badgeView = UILabel()

    private let badgeSizeFactor: CGFloat = 1.80
    private let badgeViewPercentage: CGFloat = 0.90

    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.imageView.cancelImageRequestOperation()
    }

    private func setupSubviews() {
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)

        self.badgeBorder.backgroundColor = UIColor.whiteColor()
        self.badgeBorder.alpha = 0
        self.addSubview(self.badgeBorder)

        self.badgeView.textColor = UIColor.whiteColor()
        self.badgeView.font = UIFont.getBoldFont()
        self.badgeView.textAlignment = .Center
        self.badgeView.clipsToBounds = true
        self.badgeBorder.addSubview(self.badgeView)
    }

    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()

        let radius =  CGRectGetWidth(self.frame) / 2
        let xTranslation = radius/sqrt(2)
        let yTranslation = radius/sqrt(2)

        self.imageView.setX(0)
        self.imageView.setY(0)

        self.badgeBorder.centerInSuperview()
        self.badgeBorder.moveX(xTranslation)
        self.badgeBorder.moveY(yTranslation)
        self.badgeBorder.frame = CGRectIntegral(self.badgeBorder.frame) // In order to prevent pixelation
        self.badgeBorder.layer.cornerRadius = CGRectGetWidth(self.badgeBorder.frame)/2 // In order to keep in a circle

        self.badgeView.centerInSuperview()
        self.badgeView.layer.cornerRadius = CGRectGetWidth(self.badgeView.frame) / 2
    }

    //
    // MARK: - Public Methods
    //
    func setDiameter(diameter: CGFloat) {
        self.setSize(width: diameter, height: diameter)
        self.imageView.setSize(width: diameter, height: diameter)
        self.imageView.layer.cornerRadius = diameter / 2

        let badgeBorderSize = diameter/badgeSizeFactor
        self.badgeBorder.setSize(width: badgeBorderSize, height: badgeBorderSize)

        let badgeViewSize = CGFloat(Int(badgeBorderSize * badgeViewPercentage))
        self.badgeView.setSize(width: badgeViewSize, height: badgeViewSize)
        self.badgeView.font = UIFont.getBoldFont(badgeViewSize * 0.80)

        self.layoutSubviews()
    }

    func setImageWithUser(user: User, showBadge: Bool = true) {

        self.imageView.image = UIImage.defaultProfileImage()
        if let url = user.imageURL {
            self.imageView.setImageWithURL(url)
        }
        switch user.role {
        case .Volunteer:
            self.badgeBorder.alpha = 0
        case .Admin:
            self.badgeBorder.alpha = 1
            if user.isDirector() {
                self.badgeView.text = "D"
            } else {
                self.badgeView.text = "A"
            }
        case .President:
            self.badgeBorder.alpha = 1
            self.badgeView.text = "P"
        default:
            self.badgeBorder.alpha = 0
        }

        if user.semesterSummary?.status == .Inactive {
            self.badgeBorder.alpha = 1
            self.badgeView.text = "!"
        }

        if !showBadge {
            self.badgeBorder.alpha = 0
        }
        self.badgeView.backgroundColor = user.roleColor()
    }

    func cancelImageRequestOperation() {
        self.imageView.cancelImageRequestOperation()
    }

    func resetImage() {
        self.imageView.image = UIImage.defaultProfileImage()
    }

    func image() -> UIImage {
        return self.imageView.image!
    }
}