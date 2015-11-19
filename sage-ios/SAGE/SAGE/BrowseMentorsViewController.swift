//
//  BrowseMentorsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseMentorsViewController: UITableViewController {
    
    var mentors: NSMutableArray = NSMutableArray()
    var currentErrorMessage: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mentors"
        self.tableView.tableFooterView = UIView()
        // self.loadMentors()
        
    }
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, size: size, currentError: error)
        self.currentErrorMessage = errorView
    }
    
    func loadMentors() {
        AdminOperations.loadMentors({ (mentoryArray) -> Void in
            self.mentors = mentoryArray
            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage, size: 64.0)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let school = School(name: "Sample School")
        let user = User(firstName: "Sameera", lastName: "Vemulapalli", school: school, totalHours: 99)
        let cell = BrowseMentorsTableViewCell()
        cell.configureWithUser(user)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return BrowseMentorsTableViewCell.cellHeight()
    }
    
}
