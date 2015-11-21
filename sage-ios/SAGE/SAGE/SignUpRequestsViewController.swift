//
//  SignUpRequestsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/19/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpRequestsViewController: UITableViewController {
    var requests: NSMutableArray?
    var currentErrorMessage: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up Requests"
        self.tableView.tableFooterView = UIView()
        self.loadSignUpRequests()
    }
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, size: size, currentError: error)
        self.currentErrorMessage = errorView
    }
    
    func loadSignUpRequests() {
        AdminOperations.loadSignUpRequests({ (signUpRequests) -> Void in
            self.requests = signUpRequests
            self.tableView.reloadData()
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
        let cell = sender.superview!.superview as! SignUpRequestTableViewCell
        let alertController = UIAlertController(title: "Approve", message: "Do you want to approve this sign up request?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // make a network request here
            self.removeCell(cell)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
        // make a network request, remove checkin from data source, and reload table view
    }
    
    func xButtonPressed(sender: UIButton) {
        let cell = sender.superview!.superview as! SignUpRequestTableViewCell
        self.removeCell(cell)
        // make a network request, remove checkin from data source, and reload table view
    }
    
    func removeCell(cell: SignUpRequestTableViewCell) {
        let cellID = cell.userID!
        var row = 0
        if let requests = self.requests {
            for checkin in requests {
                let checkinID = (checkin as! Checkin).id
                if checkinID != -1 && checkinID == cellID {
                    let indexPath = NSIndexPath(forRow: row, inSection: 0)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                }
                row += 1
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = self.requests![indexPath.row] as! User
        let cell = SignUpRequestTableViewCell()
        cell.configureWithUser(user)
        cell.checkButton.addTarget(self, action: "checkButtonPressed:", forControlEvents: .TouchUpInside)
        cell.xButton.addTarget(self, action: "xButtonPressed:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SignUpRequestTableViewCell.cellHeight()
    }
}