//
//  SGTitleView.swift
//  SAGE
//
//  Created by Andrew Millman on 3/1/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SGTitleView: UIView {

    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()

    private let maxWidth = CGFloat(150)
    private let smallTitleFont = UIFont.getSemiboldFont(15)
    private let normalTitleFont = UIFont.getSemiboldFont(17)

    //
    //  MARK: - Initialization
    //
    required init(title: String?, subtitle: String?) {
        super.init(frame: CGRectMake(0, 0, maxWidth, UIConstants.barbuttonSize))
        self.setupSubviews()
        self.setTitle(title)
        self.setSubtitle(subtitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        self.titleLabel.font = smallTitleFont
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.textAlignment = .Center
        self.addSubview(self.titleLabel)

        self.subtitleLabel.font = UIFont.getSemiboldFont(12)
        self.subtitleLabel.textColor = UIColor.whiteColor()
        self.subtitleLabel.alpha = 0.6
        self.subtitleLabel.textAlignment = .Center
        self.addSubview(self.subtitleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.titleLabel.sizeToFit()
        self.titleLabel.fillWidth()
        if self.subtitleLabel.hidden {
            self.titleLabel.setY(0)
            self.titleLabel.fillHeight()
        } else {
            self.titleLabel.alignBottomWithMargin(CGRectGetHeight(self.frame)/2)
        }
        
        self.subtitleLabel.sizeToFit()
        self.subtitleLabel.setY(CGRectGetMaxY(self.titleLabel.frame))
        self.subtitleLabel.fillWidth()
    }

    //
    //  MARK: - Public Methods
    //
    func title() -> String? {
        return self.titleLabel.text
    }
    
    func setTitle(title: String?) {
        self.titleLabel.text = title
        self.setProperWidth()
    }
    
    func subtitle() -> String? {
        return self.subtitleLabel.text
    }

    func setSubtitle(subtitle: String?) {
        self.subtitleLabel.text = subtitle
        if subtitle == nil || subtitle!.characters.count == 0 {
            self.titleLabel.font = normalTitleFont
            self.subtitleLabel.hidden = true
        } else {
            self.titleLabel.font = smallTitleFont
            self.subtitleLabel.hidden = false
        }
        self.setProperWidth()
    }
    
    //
    //  MARK: - Private Methods
    //
    private func setProperWidth() {
        let titleLabelWidth = self.titleLabel.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max)).width
        var subtitleLabelWidth = self.subtitleLabel.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max)).width
        if self.subtitleLabel.hidden {
            subtitleLabelWidth = 0
        }
        var finalWidth = maxWidth
        if titleLabelWidth > subtitleLabelWidth {
            finalWidth = titleLabelWidth
        } else if subtitleLabelWidth < finalWidth {
            finalWidth = subtitleLabelWidth
        }
        self.setWidth(finalWidth)
        self.layoutSubviews()
    }
}
