//
//  AnnouncementsViewController.swift
//  SAGE
//
//  Created by Erica Yin on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import FontAwesomeKit
import SwiftKeychainWrapper

class AnnouncementsViewController: SGTableViewController {
    
    var announcements: [Announcement] = []
    var filter: [String: AnyObject]?

    var currentErrorMessage: ErrorView?
    var titleView = SGTitleView(title: "Announcements", subtitle: "All")
    var page = 0
    var loadedAllAnnouncements = false
    var currentlyLoadingPage = false

    //
    // MARK: - Initialization
    //
    override init(style: UITableViewStyle) {
        super.init(style: style)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "announcementAdded:", name: NotificationConstants.addAnnouncementKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "announcementEdited:", name: NotificationConstants.editAnnouncementKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "announcementDeleted:", name: NotificationConstants.deleteAnnouncementKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userEdited:", name: NotificationConstants.editProfileKey, object: nil)
        self.setNoContentMessage("No announcements could be found :(")
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
    func announcementAdded(notification: NSNotification) {
        let announcement = notification.object!.copy() as! Announcement
        self.announcements.insert(announcement, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func announcementDeleted(notification: NSNotification) {
        let announcement = notification.object!.copy() as! Announcement
        if self.announcements.count != 0 {
            for i in 0...(self.announcements.count-1) {
                let currentAnnouncement = self.announcements[i]
                if announcement.id == currentAnnouncement.id {
                    self.announcements.removeAtIndex(i)
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    break
                }
            }
        }
    }
    
    func userEdited(notification: NSNotification) {
        let user = notification.object!.copy() as! User
        if self.announcements.count != 0 {
            for i in 0...(self.announcements.count-1) {
                let currentAnnouncement = self.announcements[i]
                if user.id == currentAnnouncement.sender!.id {
                    currentAnnouncement.sender = user
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            }
        }
    }
    
    func announcementEdited(notification: NSNotification) {
        let announcement = notification.object!.copy() as! Announcement
        if self.announcements.count != 0 {
            for i in 0...(self.announcements.count-1) {
                let oldAnnouncement = self.announcements[i]
                if announcement.id == oldAnnouncement.id {
                    self.announcements[i] = announcement
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    
    //
    // MARK: - ViewController LifeCycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        let filterIcon = FAKIonIcons.androidFunnelIconWithSize(UIConstants.barbuttonIconSize)
        let filterImage = filterIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        let filterButton = UIBarButtonItem(image: filterImage, style: .Plain, target: self, action: "showFilterOptions")

        if let role = LoginOperations.getUser()?.role {
            if role == .Admin || role == .President {
                self.navigationItem.rightBarButtonItems = [filterButton, UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showAnnouncementForm")]
            } else {
                self.navigationItem.rightBarButtonItems = [filterButton]
            }
        }
        
        self.navigationItem.titleView = self.titleView
        self.tableView.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "getAnnouncementsWithReset:", forControlEvents: .ValueChanged)
        
       self.getAnnouncements()
    }
    
    //
    // MARK: - Public Methods
    //
    func showAnnouncementForm() {
        let addAnnouncementController = AddAnnouncementController()
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(addAnnouncementController, animated: true)
    }

    func showFilterOptions() {
        let menuController = MenuController(title: "Filter Options")
        menuController.addMenuItem(MenuItem(title: "All", handler: { (_) -> Void in
            self.filter = nil
            self.getAnnouncements(reset: true, page: 0)
            self.titleView.setSubtitle("All")
        }))

        if LoginOperations.getUser()!.isDirector() {
            menuController.addMenuItem(MenuItem(title: "My School", handler: { (_) -> Void in
                self.filter = [AnnouncementConstants.kSchoolID: String(LoginOperations.getUser()!.directorID)]
                self.getAnnouncements(reset: true, page: 0)
                self.titleView.setSubtitle("My School")
            }))
        } else if let userSchool = KeychainWrapper.objectForKey(KeychainConstants.kSchool) as? School {
            menuController.addMenuItem(MenuItem(title: "My School", handler: { (_) -> Void in
                self.filter = [AnnouncementConstants.kSchoolID: String(userSchool.id)]
                self.getAnnouncements(reset: true, page: 0)
                self.titleView.setSubtitle(userSchool.name!)
            }))
        }

        if LoginOperations.getUser()!.role == .Admin || LoginOperations.getUser()!.role == .President {
            menuController.addMenuItem(ExpandMenuItem(title: "School", listRetriever: { (controller) -> Void in
                SchoolOperations.loadSchools({ (schools) -> Void in
                    controller.setList(schools)
                    }, failure: { (errorMessage) -> Void in
                })
                }, displayText: { (school: School) -> String in
                    return school.name!
                }, handler: { (selectedSchool) -> Void in
                    self.filter = [AnnouncementConstants.kSchoolID: String(selectedSchool.id)]
                    self.getAnnouncements(reset: true, page: 0)
                    self.titleView.setSubtitle(selectedSchool.name!)
            }))
        }

        self.presentViewController(menuController, animated: false, completion: nil)
    }

    func getAnnouncements(reset reset: Bool = false, page: Int = 0) {
        if reset {
            self.hideNoContentView()
            self.announcements = []
            self.tableView.reloadData()
            self.loadedAllAnnouncements = false
        }
        
        if !self.loadedAllAnnouncements {
            AnnouncementsOperations.loadAnnouncements(page: page, filter: self.filter, completion: { (newAnnouncements) -> Void in
                if newAnnouncements.count != 0 {
                    self.page = page
                    self.refreshControl?.endRefreshing()
                    
                    var indexPaths = [NSIndexPath]()
                    var i = 0
                    while i < newAnnouncements.count {
                        indexPaths.append(NSIndexPath(forRow: self.announcements.count + i, inSection: 0))
                        i = i + 1
                    }
                    
                    self.announcements.appendContentsOf(newAnnouncements)
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
                    self.tableView.endUpdates()
                    
                } else {
                    self.loadedAllAnnouncements = true
                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .None)
                    self.tableView.endUpdates()

                }
                
                if self.announcements.count == 0 {
                    self.showNoContentView()
                } else {
                    self.hideNoContentView()
                }
                
                self.currentlyLoadingPage = false
                
                }) { (errorMessage) -> Void in
                    self.refreshControl?.endRefreshing()
                    self.showErrorAndSetMessage("Could not load announcements.")
            }
        }
    }
    
    func showErrorAndSetMessage(message: String) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, currentError: error, color: UIColor.lightRedColor)
        self.currentErrorMessage = errorView
    }
    
    //
    // MARK: - UITableViewDelegate
    //
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return SGLoadingCell.cellHeight
        } else {
            return AnnouncementsTableViewCell.heightForAnnouncement(self.announcements[indexPath.row], width: CGRectGetWidth(tableView.frame))
            
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if self.loadedAllAnnouncements {
                return 0
            } else {
                return 1
            }
        } else {
            return self.announcements.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            var loadingCell = tableView.dequeueReusableCellWithIdentifier("LoadingCell")
            if (loadingCell == nil) {
                loadingCell = SGLoadingCell(style: .Default, reuseIdentifier: "LoadingCell")
            }
            (loadingCell as! SGLoadingCell).startAnimating()
            loadingCell!.userInteractionEnabled = false
            loadingCell!.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.tableView.bounds))
            self.getAnnouncements(page: self.page + 1)
            return loadingCell!
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("Announcement")
            if (cell == nil) {
                cell = AnnouncementsTableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Announcement")
            }
            let announcementsCell = cell as! AnnouncementsTableViewCell
            announcementsCell.setupWithAnnouncement(announcements[indexPath.row])
            return announcementsCell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let announcement = self.announcements[indexPath.row]
            let view = AnnouncementsDetailViewController(announcement: announcement)
            if let topItem = self.navigationController?.navigationBar.topItem {
                topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            }
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}