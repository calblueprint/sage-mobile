//
//  BrowseMentorsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit
import SwiftKeychainWrapper

class BrowseMentorsViewController: SGTableViewController {
    
    var mentors: [[User]]?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var mentorFilter : String?
    
    init() {
        super.init(style: .Plain)
        self.mentorFilter = nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BrowseMentorsViewController.userEdited(_:)), name: NotificationConstants.editProfileKey, object: nil)
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
            self.changeSubtitle(semester.displayText())
            }) { (errorMessage) -> Void in
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Mentors")
        if self.filter != nil {
            let semesterID = self.filter![SemesterConstants.kSemesterId] as! String
            self.setSemesterTitle(semesterID)
        } else {
            self.changeSubtitle("This Semester")
        }
        
        let filterIcon = FAKIonIcons.androidFunnelIconWithSize(UIConstants.barbuttonIconSize)
        let filterImage = filterIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        let filterButton = UIBarButtonItem(image: filterImage, style: .Plain, target: self, action: #selector(BrowseMentorsViewController.showFilterOptions))
        self.navigationItem.rightBarButtonItem = filterButton

        
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
        self.refreshControl?.addTarget(self, action: #selector(BrowseMentorsViewController.loadMentors), forControlEvents: .ValueChanged)
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
                return SGSectionHeaderView.sectionHeight
            }
        } else {
            return 0.0
        }
    }
    
    func showFilterOptions() {
        let menuController = MenuController(title: "Display Options")
        menuController.addMenuItem(MenuItem(title: "All", handler: { (_) -> Void in
            self.mentorFilter = nil
            self.loadMentors()
        }))
        menuController.addMenuItem(MenuItem(title: "Completed", handler: { (_) -> Void in
            self.mentorFilter = "Completed"
            self.loadMentors()
        }))
        menuController.addMenuItem(MenuItem(title: "Incomplete", handler: { (_) -> Void in
            self.mentorFilter = "Incomplete"
            self.loadMentors()

        }))
        self.presentViewController(menuController, animated: false, completion: nil)
    }
    
    func loadMentors() {
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        if self.filter == nil {
            if let _ = SAGEState.currentSemester() {
                self.setNoContentMessage("No mentors found :(")
            } else {
                self.setNoContentMessage("There is currently no semester!")
            }
        } else {
            self.setNoContentMessage("No mentors found :(")
        }
        AdminOperations.loadMentors(filter: self.filter, completion: { (mentorArray) -> Void in
            self.helperFilter(mentorArray)
            self.activityIndicator.stopAnimating()
            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage)
        }
    }
    
    func helperFilter(mentorArray: [User]) {
        var incompleteMentors = [User]()
        var completedMentors = [User]()
        for mentor in mentorArray {
            if (mentor.semesterSummary!.completed) {
                completedMentors.append(mentor)
            } else {
                incompleteMentors.append(mentor)
            }
        }
        switch self.mentorFilter {
            case .Some("Completed"):
                return self.alphabetizeAndLoad(completedMentors)
            case .Some("Incomplete"):
                return self.alphabetizeAndLoad(incompleteMentors)
            default:
                return self.alphabetizeAndLoad(mentorArray)
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SGSectionHeaderView()
        view.setSectionTitle(self.getSectionHeaderTitle(section))
        return view
    }
    
    func getSectionHeaderTitle(sectionNumber: Int) -> String {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let charAtIndex = String(alphabet[alphabet.startIndex.advancedBy(sectionNumber)])
        return charAtIndex
    }
    
}
