//
//  CheckinRequestsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/14/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class CheckinRequestsViewController: UITableViewController {

    var requests: [Checkin]?
    var filter: [String: AnyObject]?

    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var titleView = SGTitleView(title: "Check In Requests", subtitle: "All")
    
    //
    // MARK: - Init
    //
    override init(style: UITableViewStyle) {
        super.init(style: style)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userEdited:", name: NotificationConstants.editProfileKey, object: nil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //
    // MARK: - NSNotification
    //
    func userEdited(notification: NSNotification) {
        let user = notification.object!.copy() as! User
        if self.requests != nil && self.requests!.count != 0 {
            for i in 0...(self.requests!.count-1) {
                let currentRequest = self.requests![i]
                if user.id == currentRequest.user!.id {
                    currentRequest.user = user
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            }
        }
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
        self.refreshControl?.addTarget(self, action: "loadCheckinRequestsWithReset:", forControlEvents: .ValueChanged)
        
        if LoginOperations.getUser()!.isDirector() {
            self.filter = [AnnouncementConstants.kSchoolID: String(LoginOperations.getUser()!.directorID)]
            self.titleView.setSubtitle("My School")
        }
        self.loadCheckinRequests()
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
    
    func loadCheckinRequests(reset reset: Bool = false) {
        if reset {
            self.requests = nil
            self.tableView.reloadData()
            self.activityIndicator.startAnimating()
        }

        AdminOperations.loadCheckinRequests(filter: self.filter, completion: { (checkinRequests) -> Void in
            self.requests = checkinRequests
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()

            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage)
        }
    }
    
    func showFilterOptions() {
        let menuController = MenuController(title: "Filter Options")

        menuController.addMenuItem(MenuItem(title: "None", handler: { (_) -> Void in
            self.filter = nil
            self.loadCheckinRequests(reset: true)
            self.titleView.setSubtitle("All")
        }))

        if LoginOperations.getUser()!.isDirector() {
            menuController.addMenuItem(MenuItem(title: "My School", handler: { (_) -> Void in
                self.filter = [CheckinConstants.kSchoolId: String(LoginOperations.getUser()!.directorID)]
                self.loadCheckinRequests(reset: true)
                self.titleView.setSubtitle("My School")
            }))
        }

        menuController.addMenuItem(ExpandMenuItem(title: "School", listRetriever: { (controller) -> Void in
            SchoolOperations.loadSchools({ (schools) -> Void in
                controller.setList(schools)
                }, failure: { (errorMessage) -> Void in
            })
            }, displayText: { (school: School) -> String in
                return school.name!
            }, handler: { (selectedSchool) -> Void in
                self.filter = [AnnouncementConstants.kSchoolID: String(selectedSchool.id)]
                self.loadCheckinRequests(reset: true)
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
        let cell = sender.superview!.superview as! CheckinRequestTableViewCell
        let alertController = UIAlertController(title: "Approve", message: "Do you want to approve this check-in request?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.removeCell(cell, accepted: true)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func xButtonPressed(sender: UIButton) {
        let cell = sender.superview!.superview as! CheckinRequestTableViewCell
        let alertController = UIAlertController(title: "Decline", message: "Do you want to decline this check-in request?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.removeCell(cell, accepted: false)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func removeCell(cell: CheckinRequestTableViewCell, accepted: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let checkin = self.requests![indexPath.row]
        self.requests?.removeAtIndex(indexPath.row)
        if accepted {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            AdminOperations.approveCheckin(checkin, completion: { (verifiedCheckin) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.addVerifiedCheckinKey, object: verifiedCheckin)
                
                }, failure: { (message) -> Void in
                    self.requests?.insert(checkin, atIndex: indexPath.row)
                    self.tableView.reloadData()
                    self.showErrorAndSetMessage(message)
            })
        } else {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            AdminOperations.denyCheckin(checkin, completion: nil, failure: { (message) -> Void in
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
}
