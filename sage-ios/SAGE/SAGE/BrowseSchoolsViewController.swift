//
//  BrowseSchoolsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseSchoolsViewController: UITableViewController {
    
    var schools: NSMutableArray?
    var currentErrorMessage: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Schools"
        self.tableView.tableFooterView = UIView()
        self.loadSchools()
        
    }
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, size: size, currentError: error)
        self.currentErrorMessage = errorView
    }
    
    func loadSchools() {
        AdminOperations.loadSchools({ (schoolArray) -> Void in
            self.schools = schoolArray
            self.tableView.reloadData()
            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage, size: 64.0)
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
        let school = self.schools![indexPath.row] as! School
        let cell = BrowseSchoolsTableViewCell()
        cell.configureWithSchool(school)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return BrowseSchoolsTableViewCell.cellHeight()
    }
    
}
