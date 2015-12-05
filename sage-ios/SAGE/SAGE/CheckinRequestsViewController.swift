//
//  CheckinRequestsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/14/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class CheckinRequestsViewController: UITableViewController {
    var requests: [Checkin]?
    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Check In Requests"
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadCheckinRequests", forControlEvents: .ValueChanged)
        
        self.loadCheckinRequests()
    }
    
    override func viewWillLayoutSubviews() {
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }
    
    func showErrorAndSetMessage(message: String) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, currentError: error, color: UIColor.mainColor)
        self.currentErrorMessage = errorView
    }
    
    func loadCheckinRequests() {
        AdminOperations.loadCheckinRequests({ (var checkinRequests) -> Void in
            checkinRequests.sortInPlace({ (checkinOne, checkinTwo) -> Bool in
                let comparisonResult = checkinOne.startTime!.compare(checkinTwo.startTime!)
                if comparisonResult == .OrderedDescending {
                    return true
                } else {
                    return false
                }
            })
            self.requests = checkinRequests
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()

            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let requests = self.requests {
            return requests.count
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func checkButtonPressed(sender: UIButton) {
        let cell = sender.superview!.superview as! CheckinRequestTableViewCell
        let alertController = UIAlertController(title: "Approve", message: "Do you want to approve this check-in request?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // make a network request here
            self.removeCell(cell, accepted: true)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
        // make a network request, remove checkin from data source, and reload table view
    }
    
    func xButtonPressed(sender: UIButton) {
        let cell = sender.superview!.superview as! CheckinRequestTableViewCell
        let alertController = UIAlertController(title: "Decline", message: "Do you want to decline this check-in request?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // make a network request here
            self.removeCell(cell, accepted: false)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
        // make a network request, remove checkin from data source, and reload table view
    }
    
    func removeCell(cell: CheckinRequestTableViewCell, accepted: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let checkin = self.requests![indexPath.row]
        self.requests?.removeAtIndex(indexPath.row)
        if accepted {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            AdminOperations.approveCheckin(checkin, completion: nil, failure: { (message) -> Void in
                self.requests?.insert(checkin, atIndex: indexPath.row)
                self.tableView.reloadData()
                self.showErrorAndSetMessage(message)
            })
        } else {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            AdminOperations.removeCheckin(checkin, completion: nil, failure: { (message) -> Void in
                self.requests?.insert(checkin, atIndex: indexPath.row)
                self.tableView.reloadData()
                self.showErrorAndSetMessage(message)
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let checkin = self.requests![indexPath.row]
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("CheckinRequestCell")
        if cell == nil {
            cell = CheckinRequestTableViewCell(style: .Default, reuseIdentifier: "CheckinRequestCell")
        }
        (cell as! CheckinRequestTableViewCell).configureWithCheckin(checkin)
        (cell as! CheckinRequestTableViewCell).checkButton.addTarget(self, action: "checkButtonPressed:", forControlEvents: .TouchUpInside)
        (cell as! CheckinRequestTableViewCell).xButton.addTarget(self, action: "xButtonPressed:", forControlEvents: .TouchUpInside)
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let checkin = self.requests![indexPath.row]
        return CheckinRequestTableViewCell.heightForCheckinRequest(checkin, width: CGRectGetWidth(self.tableView.frame))
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let request = self.requests![indexPath.row]
        let vc = CheckinRequestsDetailViewController(checkin: request)
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
