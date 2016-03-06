//
//  SignUpRequestsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/19/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpRequestsViewController: SGTableViewController {

    var requests: [User]?
    var filter: [String: AnyObject]?

    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var titleView = SGTitleView(title: "Sign Up Requests", subtitle: "All")
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.setNoContentMessage("No new sign up requests!")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: - ViewController Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.titleView
        self.tableView.tableFooterView = UIView()
        
        let filterIcon = FAKIonIcons.androidFunnelIconWithSize(UIConstants.barbuttonIconSize)
        let filterImage = filterIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        let filterButton = UIBarButtonItem(image: filterImage, style: .Plain, target: self, action: "showFilterOptions")
        self.navigationItem.rightBarButtonItem = filterButton
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadSignUpRequestsWithReset:", forControlEvents: .ValueChanged)
        
        self.loadSignUpRequests()
    }
    
    override func viewWillLayoutSubviews() {
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }
    
    //
    // MARK: - Public Methods
    //
    func showErrorAndSetMessage(message: String) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, currentError: error, color: UIColor.mainColor)
        self.currentErrorMessage = errorView
    }
    
    func loadSignUpRequests(reset reset: Bool = false) {
        if reset {
            self.hideNoContentView()
            self.requests = nil
            self.tableView.reloadData()
            self.activityIndicator.startAnimating()
        }

        AdminOperations.loadSignUpRequests(filter: self.filter, completion: { (signUpRequests) -> Void in
            self.requests = signUpRequests
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()
            
            if self.requests == nil || self.requests?.count == 0 {
                self.showNoContentView()
            } else {
                self.hideNoContentView()
            }
            
            }) { (errorMessage) -> Void in
                self.showNoContentView()
                self.showErrorAndSetMessage(errorMessage)
        }
    }
    
    func showFilterOptions() {
        let menuController = MenuController(title: "Filter Options")
        
        menuController.addMenuItem(MenuItem(title: "None", handler: { (_) -> Void in
            self.filter = nil
            self.loadSignUpRequests(reset: true)
            self.titleView.setSubtitle("All")
        }))
        
        menuController.addMenuItem(ExpandMenuItem(title: "School", listRetriever: { (controller) -> Void in
            SchoolOperations.loadSchools({ (schools) -> Void in
                controller.setList(schools)
                }, failure: { (errorMessage) -> Void in
            })
            }, displayText: { (school: School) -> String in
                return school.name!
            }, handler: { (selectedSchool) -> Void in
                self.filter = [AnnouncementConstants.kSchoolID: String(selectedSchool.id)]
                self.loadSignUpRequests(reset: true)
                self.titleView.setSubtitle(selectedSchool.name!)
        }))
        
        self.presentViewController(menuController, animated: false, completion: nil)
    }
    
    //
    // MARK: - UITableViewDelegate
    //
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
            self.removeCell(cell, accepted: true)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func xButtonPressed(sender: UIButton) {
        let cell = sender.superview!.superview as! SignUpRequestTableViewCell
        let alertController = UIAlertController(title: "Decline", message: "Do you want to decline this sign up request?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.removeCell(cell, accepted: false)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
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
                self.hideNoContentView()
                self.showErrorAndSetMessage(message)
            })
        } else {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            AdminOperations.denyUser(user, completion: nil, failure: { (message) -> Void in
                self.requests?.insert(user, atIndex: indexPath.row)
                self.tableView.reloadData()
                self.hideNoContentView()
                self.showErrorAndSetMessage(message)
            })
        }
        if self.requests?.count == 0 {
            self.showNoContentView()
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