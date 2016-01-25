//
//  StartSemesterController.swift
//  SAGE
//
//  Created by Andrew Millman on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class StartSemesterViewController: UIViewController {
    
    var startSemesterView = StartSemesterView()
    
    private var finishButton: SGBarButtonItem?
    
    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.startSemesterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Start Semester"
        self.finishButton = SGBarButtonItem(title: "Finish", style: .Done, target: self, action: "completeForm")
        self.navigationItem.rightBarButtonItem = self.finishButton
    }
    
    //
    // MARK: - Navigation Button Handlers
    //
    @objc private func completeForm() {
        if self.startSemesterView.isValid() {
            let finalSemester = self.startSemesterView.exportToSemester()
            self.finishButton?.startLoading()
            AdminOperations.startSemester(finalSemester, completion: { (semester) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                }) { (errorMessage) -> Void in
                    self.finishButton?.stopLoading()
                    let alertController = UIAlertController(
                        title: "Failure",
                        message: errorMessage,
                        preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(
                title: "Error",
                message: "Please fill out required fields.",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}