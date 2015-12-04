//
//  ProfileCheckinViewController.swift
//  SAGE
//
//  Created by Erica Yin on 12/4/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class ProfileCheckinViewController: UITableViewController {
    var requests: [Checkin]?
    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
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
        ProfileOperations.loadCheckinRequests({ (var checkinRequests) -> Void in
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let checkin = self.requests![indexPath.row]
    
        var cell = self.tableView.dequeueReusableCellWithIdentifier("CheckinRequestCell")
        if cell == nil {
            cell = ProfileCheckinTableViewCell(style: .Default, reuseIdentifier: "CheckinRequestCell")
        }
        (cell as! ProfileCheckinTableViewCell).configureWithCheckin(checkin)
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let checkin = self.requests![indexPath.row]
        return ProfileCheckinTableViewCell.heightForCheckinRequest(checkin, width: CGRectGetWidth(self.tableView.frame))
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let request = self.requests![indexPath.row]
        let vc = CheckinRequestsDetailViewController(checkin: request)
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

