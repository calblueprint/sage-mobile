//
//  RequestHoursViewController.swift
//  SAGE
//
//  Created by Andrew on 10/27/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class RequestHoursViewController: UIViewController {
    
    var requestHoursView = RequestHoursView()
    var inSession: Bool = false
    var startTime: NSTimeInterval = 0.0
    var verified: Bool = false
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .Done, target: self, action: "completeForm")
    }
    
    //
    // MARK: - Navigation Button Handlers
    //
    @objc private func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func completeForm() {
        self.requestHoursView.exportToCheckin(self.verified)
        self.dismiss()
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
