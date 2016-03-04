//
//  NoContentView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 3/2/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class NoContentView: UIView {

    var message = "No content was found."
    var label = UILabel()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupSubviews() {
        self.alpha = 0.0
        self.userInteractionEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        self.label.text = self.message
        self.label.font = UIFont.normalFont
        self.label.textColor = UIColor.lightGrayColor()
        self.addSubview(self.label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.sizeToFit()
        self.label.centerHorizontally()
        self.label.centerVertically()
    }
    
    func useBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    func showMessage(message: String) {
        self.label.text = message
    }

}
