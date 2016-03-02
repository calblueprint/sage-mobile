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
    
    //
    //  MARK: - Initialization
    //
    required init(title: String?, subtitle: String?) {
        super.init(frame: CGRectMake(0, 0, maxWidth, UIConstants.barbuttonSize))
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.titleLabel.font = UIFont.getSemiboldFont(15)
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
        self.titleLabel.alignBottomWithMargin(CGRectGetHeight(self.frame)/2)
        self.titleLabel.fillWidth()
        
        self.subtitleLabel.sizeToFit()
        self.subtitleLabel.setY(CGRectGetMaxY(self.titleLabel.frame))
        self.subtitleLabel.fillWidth()
    }
    
    //
    //  MARK: - Public Methods
    //
    func setTitle(title: String?) {
        self.titleLabel.text = title
    }
    
    func setSubtitle(subtitle: String?) {
        self.subtitleLabel.text = subtitle
        self.layoutSubviews()
    }
}
