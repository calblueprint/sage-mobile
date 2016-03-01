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

class AnnouncementsViewController: UITableViewController {
    
    var announcements = [Announcement]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var currentErrorMessage: ErrorView?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "announcementAdded:", name: NotificationConstants.addAnnouncementKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "announcementEdited:", name: NotificationConstants.editAnnouncementKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "announcementDeleted:", name: NotificationConstants.deleteAnnouncementKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userEdited:", name: NotificationConstants.editProfileKey, object: nil)

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
                    self.tableView.reloadData()
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

        let filterIcon = FAKIonIcons.androidMoreVerticalIconWithSize(UIConstants.barbuttonIconSize)
        let filterImage = filterIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        let filterButton = UIBarButtonItem(image: filterImage, style: .Plain, target: self, action: "showFilterOptions")

        if let role = LoginOperations.getUser()?.role {
            if role == .Admin || role == .President {
                self.navigationItem.rightBarButtonItems = [filterButton, UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showAnnouncementForm")]
            } else {
                self.navigationItem.rightBarButtonItems = [filterButton]
            }
        }
        
        self.title = "Announcements"
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "getAnnouncementsWithFilter:reset:", forControlEvents: .ValueChanged)
        
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
        menuController.addMenuItem(MenuItem(title: "None", handler: { (_) -> Void in
            self.getAnnouncements(reset: true)
        }))

        if let userSchool = KeychainWrapper.objectForKey(KeychainConstants.kSchool) as? School {
            menuController.addMenuItem(MenuItem(title: "My School", handler: { (_) -> Void in
                let filter = [AnnouncementConstants.kSchoolID: String(userSchool.id)]
                self.getAnnouncements(filter: filter, reset: true)
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
                    let filter = [AnnouncementConstants.kSchoolID: String(selectedSchool.id)]
                    self.getAnnouncements(filter: filter, reset: true)
            }))
        }

        self.presentViewController(menuController, animated: false, completion: nil)
    }

    func getAnnouncements(filter filter: [String: AnyObject]? = nil, reset: Bool = false) {
        if reset {
            self.announcements = [Announcement]()
            self.tableView.reloadData()
            self.activityIndicator.startAnimating()
        }

        AnnouncementsOperations.loadAnnouncements(filter: filter, completion: { (announcements) -> Void in
            self.announcements = announcements
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()

            }) { (errorMessage) -> Void in
                self.activityIndicator.stopAnimating()
                self.refreshControl?.endRefreshing()
                self.showErrorAndSetMessage("Could not load announcements.")
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
        return AnnouncementsTableViewCell.heightForAnnouncement(announcements[indexPath.row], width: CGRectGetWidth(tableView.frame))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Announcement")
        if (cell == nil) {
            cell = AnnouncementsTableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Announcement")
        }
        let announcementsCell = cell as! AnnouncementsTableViewCell
        announcementsCell.setupWithAnnouncement(announcements[indexPath.row])
        return announcementsCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let announcement = self.announcements[indexPath.row]
        let view = AnnouncementsDetailViewController(announcement: announcement)
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(view, animated: true)
    }
}