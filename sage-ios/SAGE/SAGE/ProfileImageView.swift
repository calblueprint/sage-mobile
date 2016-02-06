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
    private var badgeView = UIImageView()

    private let badgeSizeFactor: CGFloat = 1.80
    private let badgeViewPercentage: CGFloat = 0.80

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

    private func setupSubviews() {
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)

        self.badgeBorder.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.badgeBorder)

        self.badgeView.backgroundColor = UIColor.blackColor()
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
        self.badgeBorder.frame = CGRectIntegral(self.badgeBorder.frame)
        self.badgeBorder.layer.cornerRadius = CGRectGetWidth(self.badgeBorder.frame)/2

        self.badgeView.centerInSuperview()
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
        self.badgeBorder.layer.cornerRadius = badgeBorderSize / 2

        let badgeViewSize = CGFloat(Int(badgeBorderSize * badgeViewPercentage))
        self.badgeView.setSize(width: badgeViewSize, height: badgeViewSize)
        self.badgeView.layer.cornerRadius = badgeViewSize / 2

        self.layoutSubviews()
    }

    func setImageWithUser(user: User) {

        self.imageView.image = UIImage.defaultProfileImage()
        if let url = user.imageURL {
            self.imageView.setImageWithURL(url)
        }
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