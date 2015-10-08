//
//  LoginView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.

import UIKit

class LoginView: UIView {
    
    var loginUsernameField: UITextField?
    var loginPasswordField: UITextField?
    var signUpLink: UILabel?
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }
    
    func setUpView () {
        self.setUpBackground()
        self.setUpLoginTextFields()
    }
   
    func setUpBackground() {
        let frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        let image = UIImage.init(named: UIConstants.blurredBerkeleyBackground)
        let imageView = UIImageView.init(frame: frame)
        imageView.image = image
        self.addSubview(imageView)
        
        let sageFrame = CGRectMake(0, 0, self.frame.width, self.frame.height/1.5)
        let sageLabel = UILabel.init(frame: sageFrame)
        sageLabel.text = "SAGE"
        sageLabel.textAlignment = NSTextAlignment.Center
        sageLabel.textColor = UIColor.whiteColor()
        sageLabel.font = sageLabel.font.fontWithSize(70)
        self.addSubview(sageLabel)
    }
    
    func setUpLoginTextFields() {
        // default visible
        let usernameFrame = CGRectMake(0, self.frame.height/3, self.frame.width, self.frame.height/1.5)
        self.loginUsernameField = UITextField(frame: usernameFrame)
        self.addSubview(self.loginUsernameField!)
        
    }    
    
}
