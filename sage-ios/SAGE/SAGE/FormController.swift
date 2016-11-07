//
//  FormController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class FormController: SGViewController {
    
    var finishButton: SGBarButtonItem?
    var currentErrorMessage: ErrorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.finishButton = SGBarButtonItem(title: "Finish", style: .Done, target: self, action: #selector(self.completeForm))
        self.navigationItem.rightBarButtonItem = self.finishButton

        // Do any additional setup after loading the view.
    }

    func showErrorAndSetMessage(message: String) {
        let error = self.currentErrorMessage
        let errorView = self.showError(message, currentError: error, color: UIColor.mainColor)
        self.currentErrorMessage = errorView
    }
    
    func completeForm() {
        preconditionFailure("This method must be overridden")
    }
}
