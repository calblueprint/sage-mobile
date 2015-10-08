//
//  UnverifiedViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class UnverifiedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    func setUpView() {
        self.view.backgroundColor = UIColor.redColor()
        let frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let image = UIImage.init(named: UIConstants.blurredBerkeleyBackground)
        let imageView = UIImageView.init(frame: frame)
        imageView.image = image
        self.view.addSubview(imageView)
        
        let sageFrame = CGRectMake(0 + UIConstants.verticalMargin, 0, self.view.frame.width - 2*UIConstants.verticalMargin, self.view.frame.height)
        let unverifiedLabel = UILabel.init(frame: sageFrame)
        unverifiedLabel.text = "You are currently an unverified user. Contact a SAGE administrator to be verified."
        unverifiedLabel.textAlignment = NSTextAlignment.Center
        unverifiedLabel.textColor = UIColor.whiteColor()
        unverifiedLabel.font = unverifiedLabel.font.fontWithSize(16)
        unverifiedLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        unverifiedLabel.numberOfLines = 3
        self.view.addSubview(unverifiedLabel)

    }
}
