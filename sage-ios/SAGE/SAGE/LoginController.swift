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
        self.view = LoginView.init()
    }
    
    func proceedToMainApplication() {
        // show root tab bar controller
    }
    
    
}
