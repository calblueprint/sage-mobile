//
//  AnnouncementsViewController.swift
//  SAGE
//
//  Created by Erica Yin on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class AnnouncementsViewController: UITableViewController {
    
    var announcements = [Announcement]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var currentErrorMessage: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        if let role = LoginOperations.getUser()?.role {
            if role == .Admin || role == .Director {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showAnnouncementForm")
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
        self.refreshControl?.addTarget(self, action: "getAnnouncements", forControlEvents: .ValueChanged)
        
        self.getAnnouncements()
    }
    
    func showAnnouncementForm() {
        let addAnnouncementController = AddAnnouncementController()
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(addAnnouncementController, animated: true)
    }
    
    func getAnnouncements() {
        AnnouncementsOperations.loadAnnouncements({ (announcements) -> Void in
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
        let errorView = super.showError(message, currentError: error, color: UIColor.mainColor)
        self.currentErrorMessage = errorView
    }
    
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
        let view = AnnouncementsDetailViewController(announcement: self.announcements[indexPath.row])
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(view, animated: true)
    }
}