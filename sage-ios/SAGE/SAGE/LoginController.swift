//
//  LoginController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    override func loadView() {
        super.loadView()
        self.view = LoginView.init(frame: self.view.frame)
    }
    
    func proceedToMainApplication() {
        // show root tab bar controller
    }
    
    
}
