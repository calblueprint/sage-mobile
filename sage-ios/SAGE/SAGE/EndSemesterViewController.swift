//
//  EndSemesterViewController.swift
//  SAGE
//
//  Created by Andrew on 1/1/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class EndSemesterViewController: UIViewController {

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
        self.verifyView.finalButton.addTarget(self, action: "endSemester", forControlEvents: .TouchUpInside)
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
    
    @objc private func endSemester() {
        self.verifyView.finalButton.startLoading()
        SemesterOperations.endSemester({ () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil) // Show the semester doesnt exist modal
            }) { (errorMessage) -> Void in
                self.verifyView.finalButton.stopLoading()
                let alertController = UIAlertController(
                    title: "Failure",
                    message: errorMessage,
                    preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
