//
//  ProfileCheckinViewController.swift
//  SAGE
//
//  Created by Erica Yin on 12/4/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class ProfileCheckinViewController: UITableViewController {
    var verifiedCheckins: [Checkin]?
    var unverifiedCheckins: [Checkin]?
    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    init() {
        super.init(style: .Grouped)
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
        ProfileOperations.loadCheckins({ (var checkins) -> Void in
            self.verifiedCheckins = [Checkin]()
            self.unverifiedCheckins = [Checkin]()
            for checkin in checkins {
                if checkin.verified {
                    self.verifiedCheckins!.append(checkin)
                } else {
                    self.unverifiedCheckins!.append(checkin)
                }
            }
            self.verifiedCheckins!.sortInPlace({ (checkinOne, checkinTwo) -> Bool in
                let comparisonResult = checkinOne.startTime!.compare(checkinTwo.startTime!)
                if comparisonResult == .OrderedDescending {
                    return true
                } else {
                    return false
                }
            })
            
            self.unverifiedCheckins!.sortInPlace({ (checkinOne, checkinTwo) -> Bool in
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let verifiedCheckins = self.verifiedCheckins {
            if section == 0 {
                return self.verifiedCheckins!.count
            } else {
                return self.unverifiedCheckins!.count
            }
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var checkin: Checkin
        if indexPath.section == 0 {
            checkin = self.verifiedCheckins![indexPath.row]
        } else {
            checkin = self.unverifiedCheckins![indexPath.row]
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
            checkin = self.verifiedCheckins![indexPath.row]
        } else {
            checkin = self.unverifiedCheckins![indexPath.row]
        }
        return CheckinTableViewCell.heightForCheckinRequest(checkin, width: CGRectGetWidth(self.tableView.frame))
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if (self.verifiedCheckins == nil) || (self.verifiedCheckins!.count == 0) {
                return nil
            } else {
                return "Verified Checkins"
            }
        } else {
            if (self.unverifiedCheckins == nil) || (self.unverifiedCheckins!.count == 0) {
                return nil
            } else {
                return "Unverified Checkins"
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) && ((self.verifiedCheckins == nil) || (self.verifiedCheckins!.count == 0)) {
            return 0.0
        } else if (section == 1) && ((self.unverifiedCheckins == nil) || (self.unverifiedCheckins!.count == 0)) {
            return 0.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
}

