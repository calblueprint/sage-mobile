//
//  RequestHoursViewController.swift
//  SAGE
//
//  Created by Andrew on 10/27/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class RequestHoursViewController: FormController {
    
    var requestHoursView = RequestHoursView()
    var inSession: Bool = false
    var startTime: NSTimeInterval = 0.0
    
    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.requestHoursView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "dismiss")
    }
    
    //
    // MARK: - Navigation Button Handlers
    //
    @objc private func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func completeForm() {
        if self.requestHoursView.isValid() {
            let finalCheckin = self.requestHoursView.exportToCheckinVerified(self.inSession)
            if !finalCheckin.verified && (finalCheckin.comment?.characters.count == nil || finalCheckin.comment?.characters.count == 0) {
                let alertController = UIAlertController(
                    title: "Error",
                    message: "Please add a comment.",
                    preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            self.finishButton?.startLoading()
            CheckinOperations.createCheckin(finalCheckin, success: { (checkinResponse) -> Void in
                KeychainWrapper.removeObjectForKey(KeychainConstants.kSessionStartTime)
                if checkinResponse.verified {
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.addVerifiedCheckinKey, object: checkinResponse)
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.addUnverifiedCheckinKey, object: checkinResponse)
                }
                self.dismiss()
                }) { (errorMessage) -> Void in
                    self.finishButton?.stopLoading()
                    let alertController = UIAlertController(
                        title: "Failure",
                        message: errorMessage as String,
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
    
    //
    // MARK: - Private Methods
    //
    private func setupView() {
        if inSession {
            self.title = "Session Options"
            let checkin: Checkin = Checkin()
            checkin.startTime = NSDate(timeIntervalSinceReferenceDate: self.startTime)
            checkin.endTime = NSDate()
            self.requestHoursView.setupWithCheckin(checkin)
        } else {
            self.title = "Request Hours"
        }
    }
}
