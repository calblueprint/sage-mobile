//
//  CheckinRequestsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/14/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class CheckinRequestsViewController: UITableViewController {
    var requests: NSMutableArray?
    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Check In Requests"
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadCheckinRequests", forControlEvents: .ValueChanged)
        
        self.loadCheckinRequests()
    }
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, size: size, currentError: error)
        self.currentErrorMessage = errorView
    }
    
    func loadCheckinRequests() {
        AdminOperations.loadCheckinRequests({ (checkinRequests) -> Void in
            checkinRequests.sortUsingComparator({ (checkin1id, checkin2id) -> NSComparisonResult in
                let checkinOne = checkin1id as! Checkin
                let checkinTwo = checkin2id as! Checkin
                return checkinOne.startTime!.compare(checkinTwo.startTime!)
            })
            self.requests = checkinRequests
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.refreshControl?.endRefreshing()

            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage, size: 64.0)
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
        let cellID = cell.checkinID!
        var row = 0
        if let requests = self.requests {
            for checkin in requests {
                let checkinID = (checkin as! Checkin).id
                if checkinID != -1 && checkinID == cellID {
                    let indexPath = NSIndexPath(forRow: row, inSection: 0)
                    self.requests?.removeObjectAtIndex(row)
                    if accepted {
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
                    } else {
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
                    }
                }
                row += 1
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let checkin = self.requests![indexPath.row] as! Checkin
        let cell = CheckinRequestTableViewCell()
        cell.configureWithCheckin(checkin)
        cell.checkButton.addTarget(self, action: "checkButtonPressed:", forControlEvents: .TouchUpInside)
        cell.xButton.addTarget(self, action: "xButtonPressed:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let checkin = self.requests![indexPath.row] as! Checkin
        return CheckinRequestTableViewCell.heightForCheckinRequest(checkin, width: CGRectGetWidth(self.tableView.frame))
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let request = self.requests![indexPath.row] as! Checkin
        let vc = CheckinRequestsDetailViewController(checkin: request)
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
