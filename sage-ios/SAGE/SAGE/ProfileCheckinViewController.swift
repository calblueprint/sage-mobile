//
//  ProfileCheckinViewController.swift
//  SAGE
//
//  Created by Erica Yin on 12/4/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit
import SwiftKeychainWrapper

class ProfileCheckinViewController: SGTableViewController {
    
    var user: User?
    var userCheckinSummary = ProfileCheckinSummaryView()
    var verifiedCheckins = [Checkin]()
    var unverifiedCheckins = [Checkin]()

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    //
    // MARK: - Initialization
    //
    init(user: User?) {
        super.init(style: .Grouped)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileCheckinViewController.verifiedCheckinAdded(_:)), name: NotificationConstants.addVerifiedCheckinKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileCheckinViewController.unverifiedCheckinAdded(_:)), name: NotificationConstants.addUnverifiedCheckinKey, object: nil)
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
    
    //
    // MARK: - ViewController LifeCycle
    //
    func setupHeader() {
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        self.tableView.tableHeaderView = self.userCheckinSummary
        let headerOffset = self.userCheckinSummary.boxHeight
        var headerFrame = self.tableView.tableHeaderView!.frame
        headerFrame.size.height = headerOffset
        self.userCheckinSummary.setHeight(headerOffset)
        self.userCheckinSummary.setupWithUser(user!, pastSemester: self.filter != nil)
        self.tableView.tableHeaderView = self.userCheckinSummary
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Check Ins")
        self.setupHeader()
        
        if self.filter != nil {
            let semesterID = self.filter![SemesterConstants.kSemesterId] as! String
            self.setSemesterTitle(semesterID)
        } else {
            self.changeSubtitle("This Semester")
        }
        self.tableView.tableFooterView = UIView()
        
        let filterIcon = FAKIonIcons.androidFunnelIconWithSize(UIConstants.barbuttonIconSize)
        let filterImage = filterIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        let filterButton = UIBarButtonItem(image: filterImage, style: .Plain, target: self, action: #selector(ProfileCheckinViewController.showFilterOptions))
        self.navigationItem.rightBarButtonItem = filterButton

        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        if self.filter != nil {
            self.refreshControl?.backgroundColor = UIColor.lightGrayColor
        } else {
            self.refreshControl?.backgroundColor = UIColor.mainColor
        }
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(ProfileCheckinViewController.loadCheckins(reset:)), forControlEvents: .ValueChanged)
        
        self.loadCheckins()
    }
    
    func setSemesterTitle(semesterID: String) {
        SemesterOperations.getSemester(semesterID as String, completion: { (semester) -> Void in
            self.changeSubtitle(semester.displayText())
            }) { (errorMessage) -> Void in
                self.changeSubtitle("Past Semester")
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }
    
    //
    // MARK: - Public Methods
    //
    func loadCheckins(reset reset: Bool = false) {
        if reset {
            ProfileOperations.getUser(filter: self.filter, user: self.user!, completion: { (user) -> Void in
                self.user = user
                self.userCheckinSummary.setupWithUser(self.user!, pastSemester: self.filter != nil)
                }) { (errorMessage) -> Void in
                    self.activityIndicator.stopAnimating()
                    self.showErrorAndSetMessage(errorMessage)
            }

            self.verifiedCheckins = [Checkin]()
            self.unverifiedCheckins = [Checkin]()
            self.tableView.reloadData()
            self.activityIndicator.startAnimating()
        }

        if let user = self.user {
            if filter == nil {
                if let _ = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) {
                    self.setNoContentMessage("No checkins found from this semester!")
                } else {
                    self.setNoContentMessage("There is currently no semester!")
                }
            } else {
                self.setNoContentMessage("No checkins found from this semester!")
            }
            
            ProfileOperations.loadCheckins(filter: self.filter, user: user, completion: { (checkins) -> Void in
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

                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.refreshControl?.endRefreshing()
                
                if self.verifiedCheckins.count == 0 && self.unverifiedCheckins.count == 0 {
                    self.showNoContentView()
                } else {
                    self.hideNoContentView()
                }
                
                }) { (errorMessage) -> Void in
                    self.activityIndicator.stopAnimating()
                    self.showErrorAndSetMessage(errorMessage)
            }
        }
    }
    
    func showFilterOptions() {
        let menuController = MenuController(title: "Display Options")

        if let _ = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) as? Semester {
            menuController.addMenuItem(MenuItem(title: "This Semester", handler: { (_) -> Void in
                self.filter = nil
                self.loadCheckins(reset: true)
                self.changeSubtitle("This Semester")
            }))
        }

        menuController.addMenuItem(ExpandMenuItem(title: "Choose Semester", listRetriever: { (controller) -> Void in
            SemesterOperations.loadSemesters({ (semesters) -> Void in
                controller.setList(semesters)
                }, failure: { (errorMessage) -> Void in
            })
            }, displayText: { (semester) -> String in
                return semester.displayText()
            }, handler: { (selectedSemester) -> Void in
                self.filter = [SemesterConstants.kSemesterId: String(selectedSemester.id)]
                self.loadCheckins(reset: true)
                self.changeSubtitle(selectedSemester.displayText())
        }))

        self.presentViewController(menuController, animated: false, completion: nil)
    }

    //
    // MARK: - Notification Handling
    //
    func verifiedCheckinAdded(notification: NSNotification) {
        let checkin = notification.object!.copy() as! Checkin

        var add: Bool = false
        if checkin.user?.id == self.user?.id {
            if let currentSemester = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) as? Semester {
                if let filter = self.filter {
                    if currentSemester.id == Int(filter[SemesterConstants.kSemesterId] as! String) {
                        add = true
                    }
                } else {
                    add = true
                }
            }
        }
        if add {
            self.hideNoContentView()
            self.verifiedCheckins.insert(checkin, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func unverifiedCheckinAdded(notification: NSNotification) {
        let checkin = notification.object!.copy() as! Checkin

        var add: Bool = false
        if checkin.user?.id == self.user?.id {
            if let currentSemester = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) as? Semester {
                if let filter = self.filter {
                    if currentSemester.id == Int(filter[SemesterConstants.kSemesterId] as! String) {
                        add = true
                    }
                } else {
                    add = true
                }
            }
        }
        if add {
            self.hideNoContentView()
            self.unverifiedCheckins.insert(checkin, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection:1)
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

