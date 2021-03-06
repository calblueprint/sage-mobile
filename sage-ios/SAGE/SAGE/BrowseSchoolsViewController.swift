//
//  BrowseSchoolsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseSchoolsViewController: SGTableViewController {
    
    var schools: [School]?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "schoolAdded:", name: NotificationConstants.addSchoolKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "schoolEdited:", name: NotificationConstants.editSchoolKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "schoolDeleted:", name: NotificationConstants.deleteSchoolKey, object: nil)
        self.setNoContentMessage("No schools currently exist.")
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
    
    //
    // MARK: - NSNotificationCenter selectors
    //
    func schoolAdded(notification: NSNotification) {
        let school = notification.object!.copy() as! School
        if let _ = self.schools {
            self.hideNoContentView()
            self.schools!.insert(school, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    func schoolDeleted(notification: NSNotification) {
        let school = notification.object!.copy() as! School
        if self.schools!.count != 0 {
            for i in 0...(self.schools!.count-1) {
                let currentSchool = self.schools![i]
                if school.id == currentSchool.id {
                    self.schools!.removeAtIndex(i)
                    if self.schools!.count == 0 {
                        self.showNoContentView()
                    }
                    self.tableView.reloadData()
                    break
                }
            }
        }
    }
    
    func schoolEdited(notification: NSNotification) {
        let school = notification.object!.copy() as! School
        if let _ = self.schools {
            for i in 0...(self.schools!.count-1) {
                let oldSchool = self.schools![i]
                if school.id == oldSchool.id {
                    self.schools![i] = school
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Schools")
        self.tableView.tableFooterView = UIView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addSchool")

        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadSchools", forControlEvents: .ValueChanged)
        
        self.loadSchools()
        
    }
    
    override func viewWillLayoutSubviews() {
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }
    
    func addSchool() {
        let addSchoolController = AddSchoolController()
        self.navigationController?.pushViewController(addSchoolController, animated: true)
    }
    
    func loadSchools() {
        AdminOperations.loadSchools({ (schoolArray) -> Void in
            self.schools = schoolArray
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()
            
            if self.schools == nil || self.schools?.count == 0 {
                self.showNoContentView()
            } else {
                self.hideNoContentView()
            }
            
            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage)
        }
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SchoolsTableViewCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let school = self.schools![indexPath.row]
        let vc = SchoolDetailViewController()
        vc.configureWithSchool(school)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
