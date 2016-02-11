//
//  ProfileCheckinViewController.swift
//  SAGE
//
//  Created by Erica Yin on 12/4/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class ProfileCheckinViewController: UITableViewController {
    
    var user: User?
    var verifiedCheckins = [Checkin]()
    var unverifiedCheckins = [Checkin]()
    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    init(user: User?) {
        super.init(style: .Grouped)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "verifiedCheckinAdded:", name: NotificationConstants.addVerifiedCheckinKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unverifiedCheckinAdded:", name: NotificationConstants.addUnverifiedCheckinKey, object: nil)
        self.user = user
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Check Ins"
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadCheckins", forControlEvents: .ValueChanged)
        
        self.loadCheckins()
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
    
    func loadCheckins() {
        if let user = self.user {
            ProfileOperations.loadCheckins(user, completion: { (checkins) -> Void in
                self.verifiedCheckins = [Checkin]()
                self.unverifiedCheckins = [Checkin]()
                for checkin in checkins {
                    if checkin.verified {
                        self.verifiedCheckins.append(checkin)
                    } else {
                        self.unverifiedCheckins.append(checkin)
                    }
                }
                self.verifiedCheckins.sortInPlace({ (checkinOne, checkinTwo) -> Bool in
                    let comparisonResult = checkinOne.startTime!.compare(checkinTwo.startTime!)
                    if comparisonResult == .OrderedDescending {
                        return true
                    } else {
                        return false
                    }
                })
                
                self.unverifiedCheckins.sortInPlace({ (checkinOne, checkinTwo) -> Bool in
                    let comparisonResult = checkinOne.startTime!.compare(checkinTwo.startTime!)
                    if comparisonResult == .OrderedDescending {
                        return true
                    } else {
                        return false
                    }
                })
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.refreshControl?.endRefreshing()
                
                }) { (errorMessage) -> Void in
                    self.showErrorAndSetMessage(errorMessage)
            }
        }
    }
    
    //
    // MARK: - Notification Handling
    //
    func verifiedCheckinAdded(notification: NSNotification) {
        let checkin = notification.object!.copy() as! Checkin
        if checkin.user?.id == self.user?.id {
            self.verifiedCheckins.insert(checkin, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func unverifiedCheckinAdded(notification: NSNotification) {
        let checkin = notification.object!.copy() as! Checkin
        if checkin.user?.id == self.user?.id {
            self.unverifiedCheckins.insert(checkin, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 1)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    //
    // MARK: - UITableViewDelegate
    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.verifiedCheckins.count
        } else {
            return self.unverifiedCheckins.count
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var checkin: Checkin
        if indexPath.section == 0 {
            checkin = self.verifiedCheckins[indexPath.row]
        } else {
            checkin = self.unverifiedCheckins[indexPath.row]
        }
    
        var cell = self.tableView.dequeueReusableCellWithIdentifier("CheckinRequestCell")
        if cell == nil {
            cell = CheckinTableViewCell(style: .Default, reuseIdentifier: "CheckinRequestCell")
        }
        (cell as! CheckinTableViewCell).configureWithCheckin(checkin)
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var checkin: Checkin
        if indexPath.section == 0 {
            checkin = self.verifiedCheckins[indexPath.row]
        } else {
            checkin = self.unverifiedCheckins[indexPath.row]
        }
        return CheckinTableViewCell.heightForCheckinRequest(checkin, width: CGRectGetWidth(self.tableView.frame))
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if (self.verifiedCheckins.count == 0) {
                return nil
            } else {
                return "Verified Checkins"
            }
        } else {
            if (self.unverifiedCheckins.count == 0) {
                return nil
            } else {
                return "Unverified Checkins"
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) && (self.verifiedCheckins.count == 0) {
            return 0.0
        } else if (section == 1) && (self.unverifiedCheckins.count == 0) {
            return 0.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
}

