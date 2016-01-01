//
//  SemesterVerifyViewController.swift
//  SAGE
//
//  Created by Andrew on 1/1/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class SemesterVerifyViewController: UIViewController {

    let verifyView = SemesterVerifyView()

    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.verifyView
    }
}
