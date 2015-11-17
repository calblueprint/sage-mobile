//
//  CheckinRequestsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/14/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class CheckinRequestsViewController: UITableViewController {
    var requests: NSMutableArray = NSMutableArray()
    var currentErrorMessage: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Check In Requests"
        self.tableView.tableFooterView = UIView()
        // self.loadMentors()
    }
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, size: size, currentError: error)
        self.currentErrorMessage = errorView
    }
    
    func loadMentors() {
        AdminOperations.loadCheckinRequests({ (checkinRequests) -> Void in
            self.requests = checkinRequests
            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage, size: 64.0)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func checkButtonPressed(sender: UIButton) {
        let cell = sender.superview as! CheckinRequestTableViewCell
        self.removeCellFromDataSource(cell)
        // make a network request, remove checkin from data source, and reload table view
    }
    
    func xButtonPressed(sender: UIButton) {
        let cell = sender.superview as! CheckinRequestTableViewCell
        self.removeCellFromDataSource(cell)
        // make a network request, remove checkin from data source, and reload table view
    }
    
    func removeCellFromDataSource(cell: CheckinRequestTableViewCell) {
        // remove the cell from the array and then reload the data
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let url = NSURL(string: "http://i1.wp.com/pmcdeadline2.files.wordpress.com/2014/09/matt_bomer_white_collar_wallpaper-t2.jpg?crop=0px%2C10px%2C400px%2C268px&resize=446%2C299")
        let checkin = Checkin(user: User(firstName: "Alison", lastName: "Reichl", imgURL: url), startTime: NSDate(timeIntervalSinceNow: 0), endTime: NSDate(timeIntervalSinceNow: 1000),comment: "some sort of excuse blah blah blah as;ldkfjals;kjf blah balh")
        if indexPath.row == 1 {
            checkin.comment = "shsome sort of excuse blah blah blah as;ldkfjals;kjf blah balhsome sort of excuse blah blah blah as;ldkfjals;kjf blah balhsome sort of excuse blah blah blah as;ldkfjals;kjf blah balhsome sort of excuse blah blah blah as;ldkfjals;kjf blah balhort"
        }
        let cell = CheckinRequestTableViewCell()
        cell.configureWithCheckin(checkin)
        cell.checkButton.addTarget(self, action: "checkButtonPressed:", forControlEvents: .TouchUpInside)
        cell.xButton.addTarget(self, action: "xButtonPressed:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let url = NSURL(string: "http://i1.wp.com/pmcdeadline2.files.wordpress.com/2014/09/matt_bomer_white_collar_wallpaper-t2.jpg?crop=0px%2C10px%2C400px%2C268px&resize=446%2C299")
        let checkin = Checkin(user: User(firstName: "Alison", lastName: "Reichl", imgURL: url), startTime: NSDate(timeIntervalSinceNow: 0), endTime: NSDate(timeIntervalSinceNow: 1000),comment: "some sort of excuse blah blah blah as;ldkfjals;kjf blah balh")
        if indexPath.row == 1 {
            checkin.comment = "shsome sort of excuse blah blah blah as;ldkfjals;kjf blah balhsome sort of excuse blah blah blah as;ldkfjals;kjf blah balhsome sort of excuse blah blah blah as;ldkfjals;kjf blah balhsome sort of excuse blah blah blah as;ldkfjals;kjf blah balhort"
        }
        return CheckinRequestTableViewCell.heightForCheckinRequest(checkin, width: CGRectGetWidth(self.tableView.frame))
    }
}
