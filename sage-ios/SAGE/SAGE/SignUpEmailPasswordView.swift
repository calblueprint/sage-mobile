//
//  SignUpEmailPasswordView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpEmailPasswordView: SignUpFormView {
    
    var emailInput: UITextField = UITextField()
    var passwordInput: UITextField = UITextField()
    
    override func setUpViews() {
        super.setUpViews()
        // add everything to the containerview
        self.containerView.addSubview(self.emailInput)
        self.containerView.addSubview(self.passwordInput)
        self.emailInput.textColor = UIColor.whiteColor()
        self.passwordInput.textColor = UIColor.whiteColor()
        
        self.emailInput.placeholder = "Email"
        self.passwordInput.placeholder = "Password"
        self.headerLabel.text = "Great!"
        self.subHeaderLabel.text = "What's your email and password?"
        
        // set icon and color
    }
}
