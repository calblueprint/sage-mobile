//
//  SignUpNameView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpNameView: SignUpFormView {
    
    var firstNameInput: UITextField = UITextField()
    var lastNameInput: UITextField = UITextField()
    
    override func setUpViews() {
        super.setUpViews()
        // add everything to the containerview
        self.containerView.addSubview(self.firstNameInput)
        self.containerView.addSubview(self.lastNameInput)
        self.firstNameInput.textColor = UIColor.whiteColor()
        self.lastNameInput.textColor = UIColor.whiteColor()
        
        self.firstNameInput.placeholder = "First name"
        self.lastNameInput.placeholder = "Last name"
        self.headerLabel.text = "Welcome to SAGE!"
        self.subHeaderLabel.text = "What's your name?"
        // set icon and color
    }

}
