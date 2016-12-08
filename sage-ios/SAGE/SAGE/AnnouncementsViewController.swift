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
    
    var page = 0
    var loadedAllAnnouncements = false
    var announcements = [Announcement]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    //
    // MARK: - Initialization
    //
    override init(style: UITableViewStyle) {
        super.init(style: style)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnnouncementsViewController.announcementAdded(_:)), name: NotificationConstants.addAnnouncementKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnnouncementsViewController.announcementEdited(_:)), name: NotificationConstants.editAnnouncementKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnnouncementsViewController.announcementDeleted(_:)), name: NotificationConstants.deleteAnnouncementKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnnouncementsViewController.userEdited(_:)), name: NotificationConstants.editProfileKey, object: nil)
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
        self.setTitle("Announcements", subtitle: "All")
        self.view.backgroundColor = UIColor.whiteColor()

        let filterIcon = FAKIonIcons.androidFunnelIconWithSize(UIConstants.barbuttonIconSize)
        let filterImage = filterIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        let filterButton = UIBarButtonItem(image: filterImage, style: .Plain, target: self, action: #selector(AnnouncementsViewController.showFilterOptions))

        if let role = SAGEState.currentUser()?.role {
            if role == .Admin || role == .President {
                self.navigationItem.rightBarButtonItems = [filterButton, UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(AnnouncementsViewController.showAnnouncementForm))]
            } else {
                self.navigationItem.rightBarButtonItems = [filterButton]
            }
        }
        
        self.tableView.tableFooterView = UIView()
    }
    
    //
    // MARK: - Public Methods
    //
    func showAnnouncementForm() {
        let addAnnouncementController = AddAnnouncementController()
        self.navigationController?.pushViewController(addAnnouncementController, animated: true)
    }

    func showFilterOptions() {
        let menuController = MenuController(title: "Display Options")
        menuController.addMenuItem(MenuItem(title: "All", handler: { (_) -> Void in
            self.filter = nil
            self.getAnnouncements(reset: true)
            self.changeSubtitle("All")
        }))

        if SAGEState.currentUser()!.isDirector() {
            menuController.addMenuItem(MenuItem(title: "My School", handler: { (_) -> Void in
                self.filter = [AnnouncementConstants.kSchoolID: String(SAGEState.currentUser()!.directorID)]
                self.getAnnouncements(reset: true)
                self.changeSubtitle("My School")
            }))
        } else if let userSchool = SAGEState.currentSchool() {
            menuController.addMenuItem(MenuItem(title: "My School", handler: { (_) -> Void in
                self.filter = [AnnouncementConstants.kSchoolID: String(userSchool.id)]
                self.getAnnouncements(reset: true)
                self.changeSubtitle(userSchool.name!)
            }))
        }

        if SAGEState.currentUser()!.role == .Admin || SAGEState.currentUser()!.role == .President {
            menuController.addMenuItem(ExpandMenuItem(title: "School", listRetriever: { (controller) -> Void in
                SchoolOperations.loadSchools({ (schools) -> Void in
                    controller.setList(schools)
                    }, failure: { (errorMessage) -> Void in
                })
                }, displayText: { (school: School) -> String in
                    return school.name!
                }, handler: { (selectedSchool) -> Void in
                    self.filter = [AnnouncementConstants.kSchoolID: String(selectedSchool.id)]
                    self.getAnnouncements(reset: true)
                    self.changeSubtitle(selectedSchool.name!)
            }))
        }

        self.presentViewController(menuController, animated: false, completion: nil)
    }
    
    func fetchAnnouncements() {
        self.getAnnouncements()
    }

    func getAnnouncements(reset reset: Bool = false, page: Int = 1) {
        if reset {
            self.hideNoContentView()
            self.announcements = []
            self.page = 0
            self.tableView.reloadData()
            self.loadedAllAnnouncements = false
        }
        
        // Want to get first batch of announcements again
        if page == 1 {
            self.announcements = []
            self.page = 0
            self.loadedAllAnnouncements = false
        }
        
        if !self.loadedAllAnnouncements {
            AnnouncementsOperations.loadAnnouncements(page: page, filter: self.filter, completion: { (newAnnouncements) -> Void in
                self.refreshControl?.endRefreshing()
                if newAnnouncements.count != 0 {
                    self.page = page
                    
                    var indexPaths = [NSIndexPath]()
                    var i = 0
                    while i < newAnnouncements.count {
                        indexPaths.append(NSIndexPath(forRow: self.announcements.count + i, inSection: 0))
                        i = i + 1
                    }
                    
                    self.announcements.appendContentsOf(newAnnouncements)
                    
                    self.tableView.reloadData()
                } else {
                    self.loadedAllAnnouncements = true
                    self.tableView.reloadData()

                }
                
                if self.announcements.count == 0 {
                    self.showNoContentView()
                } else {
                    self.hideNoContentView()
                }

                }) { (errorMessage) -> Void in
                    self.refreshControl?.endRefreshing()
                    self.showErrorAndSetMessage("Could not load announcements.")
            }
        }
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
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
