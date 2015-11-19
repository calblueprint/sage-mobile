//
//  BrowseMentorsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseMentorsViewController: UITableViewController {
    
    var mentors: NSMutableArray?
    var currentErrorMessage: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mentors"
        self.tableView.tableFooterView = UIView()
        self.loadMentors()
        
    }
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, size: size, currentError: error)
        self.currentErrorMessage = errorView
    }
    
    func loadMentors() {
        AdminOperations.loadMentors({ (mentorArray) -> Void in
            let alphabet = Array(arrayLiteral: "abcdefghijklmnopqrstuvwxyz")
            var charArray = [String: Int]()
            self.mentors = NSMutableArray()
            for i in 0...25 {
                self.mentors!.addObject(NSMutableArray())
                charArray[alphabet[i]] = i
            }
            
            for mentor in mentorArray {
                let firstLetter = Array(arrayLiteral: (mentor as! User).firstName!)[0]
                let firstLetterIndex = charArray[firstLetter]
                self.mentors![firstLetterIndex!].addObject(mentor)
            }
            
            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage, size: 64.0)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mentors = self.mentors {
            return mentors[section].count
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let mentors = self.mentors {
            return mentors.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = self.mentors![indexPath.section][indexPath.row] as! User
        let cell = BrowseMentorsTableViewCell()
        cell.configureWithUser(user)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return BrowseMentorsTableViewCell.cellHeight()
    }
    
}
