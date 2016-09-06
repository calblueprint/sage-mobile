//
//  SuccessView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 4/20/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SuccessView: UIView {

    var message: UILabel = UILabel()
    var background: UIView = UIView()
    var centered: Bool = true

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(height: CGFloat, messageString: String, color: UIColor = UIColor.whiteColor(), alpha: CGFloat? = 1.0, centered: Bool? = true) {
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let newFrame = CGRectMake(0, 0, screenWidth, height)
        self.init(frame: newFrame)

        self.addSubview(self.background)
        self.background.backgroundColor = color
        self.background.alpha = alpha!

        self.background.addSubview(self.message)
        self.message.text = messageString
        self.message.textColor = UIColor.whiteColor()
        self.message.font = UIFont.normalFont
        self.message.lineBreakMode = .ByWordWrapping
        self.message.numberOfLines = 2
        self.centered = centered!

        self.userInteractionEnabled = true
        let successTapRecognizer = UITapGestureRecognizer()
        successTapRecognizer.addTarget(self, action: #selector(SuccessView.errorMessageTapped))
        self.addGestureRecognizer(successTapRecognizer)
    }

    func errorMessageTapped() {
        self.alpha = 0.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.background.fillHeight()
        self.background.fillWidth()

        self.message.sizeToFit()
        self.message.centerHorizontally()
        self.message.centerVertically()
        if !self.centered {
            self.message.setY(self.message.frame.origin.y + 10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
