//
//  SplashView.swift
//  SAGE
//
//  Created by Erica Yin on 4/21/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation
import UIKit

class SplashView: UIView {
    
    var splashView = UIImageView()
    var animated: Bool
    
    init(frame: CGRect, animated: Bool) {
        self.animated = animated
        super.init(frame: frame)
        self.addSubview(self.splashView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.fillWidth()
        self.fillHeight()
        self.backgroundColor = UIColor.redColor()
        self.splashView.fillWidth()
        self.splashView.fillHeight()
        if self.animated {
            self.splashView.image = UIImage.animatedImageNamed("splash-", duration: 1.5)
        } else {
            self.splashView.image = UIImage(named: "initial-splash")
        }
    }

}
