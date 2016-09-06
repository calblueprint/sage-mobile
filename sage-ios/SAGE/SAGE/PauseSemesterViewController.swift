//
//  PauseSemesterViewController.swift
//  SAGE
//
//  Created by Andrew Millman on 7/6/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class PauseSemesterViewController: SGViewController {
    
    let pauseView = PauseSemesterView()
    
    weak var presentingNavigationController: UINavigationController?
    
    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.pauseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pauseView.cancelIconButton.addTarget(self, action: #selector(PauseSemesterViewController.cancelPressed), forControlEvents: .TouchUpInside)
        self.pauseView.cancelButton.addTarget(self, action: #selector(PauseSemesterViewController.cancelPressed), forControlEvents: .TouchUpInside)
        self.pauseView.continueButton.addTarget(self, action: #selector(PauseSemesterViewController.confirmPause), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    @objc private func confirmPause() {
        let alertController = UIAlertController(
            title: "Are you sure?",
            message: "Would you like to give a break next week?",
            preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) in
            self.pauseSemester()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @objc private func pauseSemester() {
        self.pauseView.continueButton.startLoading()
        SemesterOperations.pauseSemester({ () -> Void in
            self.pauseView.continueButton.stopLoading()
            self.pauseView.showAnnouncementPrompt {
                self.pauseView.continueButton.addTarget(self, action: #selector(PauseSemesterViewController.showCreateAnnouncement), forControlEvents: .TouchUpInside)
            }
        }) { (errorMessage) -> Void in
            self.pauseView.continueButton.stopLoading()
            let alertController = UIAlertController(
                title: "Failure",
                message: errorMessage,
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    @objc private func showCreateAnnouncement() {
        self.dismissViewControllerAnimated(true) {
            if let navigationController = self.presentingNavigationController {
                let addAnnouncementVC = AddAnnouncementController()
                addAnnouncementVC.addAnnouncementView.title.textField.text = "Break Next Week"
                navigationController.pushViewController(addAnnouncementVC, animated: true)
            }
        }
    }

}
