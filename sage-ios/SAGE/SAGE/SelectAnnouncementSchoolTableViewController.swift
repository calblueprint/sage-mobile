//
//  SelectAnnouncementSchoolTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/24/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SelectAnnouncementSchoolTableViewController: SGTableViewController {
    
    var schools: [School]?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
    weak var parentVC: AddAnnouncementController?
    var currentErrorMessage: ErrorView?
    let everyoneSchool = School(id: -1, name: "Everyone", students: [User]())
    
    init() {
        super.init(style: .Plain)
        self.setNoContentMessage("Could not find any schools.")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose School"
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadSchools", forControlEvents: .ValueChanged)
        
        self.loadSchools()
    }
    
    func loadSchools() {
        AdminOperations.loadSchools({ (schoolArray) -> Void in
            self.schools = schoolArray
            self.schools?.insert(self.everyoneSchool, atIndex: 0)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()
            
            if self.schools?.count == 0 {
                self.showNoContentView()
            } else {
                self.hideNoContentView()
            }
            
            }) { (errorMessage) -> Void in
                self.showNoContentView()
                self.showErrorAndSetMessage(errorMessage)
        }
    }
    
    func showErrorAndSetMessage(message: String) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, currentError: error, color: UIColor.mainColor)
        self.currentErrorMessage = errorView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let schools = self.schools {
            return schools.count
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let school = self.schools![indexPath.row]
        var cell = self.tableView.dequeueReusableCellWithIdentifier("BrowseSchoolsCell")
        if cell == nil {
            cell = SchoolsTableViewCell(style: .Subtitle, reuseIdentifier: "BrowseSchoolsCell")
        }
        (cell as! SchoolsTableViewCell).configureWithSchool(school)
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.parentVC?.didSelectSchool(self.schools![indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SchoolsTableViewCell.cellHeight()
    }
}