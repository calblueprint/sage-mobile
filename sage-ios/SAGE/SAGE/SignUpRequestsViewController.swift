//
//  SignUpRequestsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/19/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpRequestsViewController: UITableViewController {
    var requests: [User]?
    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up Requests"
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadSignUpRequests", forControlEvents: .ValueChanged)
        
        self.loadSignUpRequests()
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
    
    func loadSignUpRequests() {
        AdminOperations.loadSignUpRequests({ (signUpRequests) -> Void in
            self.requests = signUpRequests
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
        let cell = sender.superview!.superview as! SignUpRequestTableViewCell
        let alertController = UIAlertController(title: "Approve", message: "Do you want to approve this sign up request?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // make a network request here
            self.removeCell(cell, accepted: true)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
        // make a network request, remove checkin from data source, and reload table view
    }
    
    func xButtonPressed(sender: UIButton) {
        let cell = sender.superview!.superview as! SignUpRequestTableViewCell
        let alertController = UIAlertController(title: "Decline", message: "Do you want to decline this sign up request?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // make a network request here
            self.removeCell(cell, accepted: false)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
        // make a network request, remove checkin from data source, and reload table view
    }
    
    
    func removeCell(cell: SignUpRequestTableViewCell, accepted: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let user = self.requests![indexPath.row]
        self.requests?.removeAtIndex(indexPath.row)
        if accepted {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            AdminOperations.verifyUser(user, completion: nil, failure: { (message) -> Void in
                self.requests?.insert(user, atIndex: indexPath.row)
                self.tableView.reloadData()
                self.showErrorAndSetMessage(message)
            })
        } else {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            AdminOperations.denyUser(user, completion: nil, failure: { (message) -> Void in
                self.requests?.insert(user, atIndex: indexPath.row)
                self.tableView.reloadData()
                self.showErrorAndSetMessage(message)
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = self.requests![indexPath.row]
        var cell = self.tableView.dequeueReusableCellWithIdentifier("SignUpRequestCell")
        if cell == nil {
            cell = SignUpRequestTableViewCell(style: .Default, reuseIdentifier: "SignUpRequestCell")
        }
        (cell as! SignUpRequestTableViewCell).configureWithUser(user)
        (cell as! SignUpRequestTableViewCell).checkButton.addTarget(self, action: "checkButtonPressed:", forControlEvents: .TouchUpInside)
        (cell as! SignUpRequestTableViewCell).xButton.addTarget(self, action: "xButtonPressed:", forControlEvents: .TouchUpInside)
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SignUpRequestTableViewCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let request = self.requests![indexPath.row]
        let vc = ProfileViewController(user: request)
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}