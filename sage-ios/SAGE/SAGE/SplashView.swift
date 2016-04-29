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
    let animationDuration = 1.7
    
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
        self.splashView.fillWidth()
        self.splashView.fillHeight()
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.clearColor()
        if self.animated {
            var animatedImagesArray = [UIImage]()
            for (var i = 1; i < 38; i += 1) {
                let imageName = "splash-" + String(i)
                animatedImagesArray.append(UIImage(named: imageName)!)
            }
            self.splashView.animationImages = animatedImagesArray
            self.splashView.animationDuration = self.animationDuration
            self.splashView.animationRepeatCount = 1
            self.splashView.startAnimating()
        } else {
            self.splashView.image = UIImage(named: "initial-splash")
        }
    }
}
