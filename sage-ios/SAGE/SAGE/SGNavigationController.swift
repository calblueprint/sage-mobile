//
//  SGNavigationController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 4/20/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SGNavigationController: UINavigationController {

    private var successView: SuccessView?

    override func showSuccessAndSetMessage(message: String) {
        let success = self.successView
        let successView = super.showSuccess(message, currentSuccess: success, color: UIColor.lightGreenColor)
        self.successView = successView
    }

}
