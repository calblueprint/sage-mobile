//
//  BrowseMentorsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class BrowseMentorsViewController: SGTableViewController {
    
    var mentors: [[User]]?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var titleView = SGTitleView(title: "Mentors", subtitle: "")
    
    init() {
        super.init(style: .Plain)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userEdited:", name: NotificationConstants.editProfileKey, object: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func userEdited(notification: NSNotification) {
        let newUser = notification.object!.copy() as! User
        var users = [User]()
        if self.mentors != nil && self.mentors!.count != 0 {
            for subArray in self.mentors! {
                for oldUser in subArray {
                    if oldUser.id == newUser.id {
                        users.append(newUser)
                    } else {
                        users.append(oldUser)
                    }
                }
            }
        }
        self.alphabetizeAndLoad(users)
    }
    
    func setSemesterTitle(semesterID: String) {
        SemesterOperations.getSemester(semesterID as String, completion: { (semester) -> Void in
            self.titleView.setSubtitle(semester.displayText())
            }) { (errorMessage) -> Void in
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.filter != nil {
            let semesterID = self.filter![SemesterConstants.kSemesterId] as! String
            self.setSemesterTitle(semesterID)
        } else {
            self.titleView.setSubtitle("This Semester")
        }
        self.navigationItem.titleView = self.titleView
        
        self.tableView.sectionIndexColor = UIColor.mainColor
        self.tableView.tableFooterView = UIView()
        self.tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        if self.filter != nil {
            self.refreshControl?.backgroundColor = UIColor.lightGrayColor
        } else {
            self.refreshControl?.backgroundColor = UIColor.mainColor
        }
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadMentors", forControlEvents: .ValueChanged)
        
        self.loadMentors()
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letterChar = alphabet[alphabet.startIndex.advancedBy(section)]
        return String(letterChar)
    }
    
    override func viewWillLayoutSubviews() {
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var charArray = [String]()
        for i in 0...25 {
            let letterChar = alphabet[alphabet.startIndex.advancedBy(i)]
            let letterString = String(letterChar)
            charArray.append(letterString)
        }
        return charArray
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = self.mentors {
            if self.mentors![section].count == 0 {
                return 0.0
            } else {
                return 22.0
            }
        } else {
            return 0.0
        }
    }
    
    func loadMentors() {
        if filter == nil {
            if let _ = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) {
                self.setNoContentMessage("No mentors found :(")
            } else {
                self.setNoContentMessage("There is currently no semester!")
            }
        } else {
            self.setNoContentMessage("No mentors found :(")
        }
        
        AdminOperations.loadMentors(filter: self.filter, completion: { (mentorArray) -> Void in
            self.alphabetizeAndLoad(mentorArray)
            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage)
        }
    }
    
    func alphabetizeAndLoad(mentorArray: [User]) {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var charArray = [String: Int]()
        self.mentors = [[User]]()
        for i in 0...25 {
            self.mentors!.append([User]())
            let letterChar = alphabet[alphabet.startIndex.advancedBy(i)]
            let letterString = String(letterChar)
            charArray[letterString] = i
        }
        
        for mentor in mentorArray {
            let firstName = mentor.firstName!
            let firstLetter = String(firstName[firstName.startIndex.advancedBy(0)]).lowercaseString
            let firstLetterIndex = charArray[firstLetter]
            self.mentors![firstLetterIndex!].append(mentor)
        }
        
        var empty = true
        for mentorArray in self.mentors! {
            if mentorArray.count != 0 {
                empty = false
            }
        }
        
        if empty {
            self.showNoContentView()
        } else {
            self.hideNoContentView()
        }
        
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        self.refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mentors = self.mentors {
            return mentors[section].count
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 26
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var charArray = [String: Int]()
        for i in 0...25 {
            let letterChar = alphabet[alphabet.startIndex.advancedBy(i)]
            let letterString = String(letterChar)
            charArray[letterString] = i
        }
        return charArray[title.lowercaseString]!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = self.mentors![indexPath.section][indexPath.row]
        var cell = self.tableView.dequeueReusableCellWithIdentifier("BrowseMentorsCell")
        if cell == nil {
            cell = UsersTableViewCell(style: .Default, reuseIdentifier: "BrowseMentorsCell")
        }
        (cell as! UsersTableViewCell).configureWithUser(user)
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UsersTableViewCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mentor = self.mentors![indexPath.section][indexPath.row]
        let vc = ProfileViewController(user: mentor)
        vc.filter = self.filter
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
