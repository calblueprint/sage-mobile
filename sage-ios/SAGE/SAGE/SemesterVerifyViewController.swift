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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.verifyView.cancelButton.addTarget(self, action: "cancelPressed", forControlEvents: .TouchUpInside)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.verifyView.showFirstLabel()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    //
    // MARK: - Event Handling
    //
    @objc private func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
