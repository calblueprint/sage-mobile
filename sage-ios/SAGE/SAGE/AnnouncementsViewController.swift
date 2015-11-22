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
        self.title = "Announcements"
        
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
    
    func getAnnouncements() {
        AnnouncementsOperations.loadAnnouncements({ (announcements) -> Void in
            self.announcements = announcements
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()

            }) { (errorMessage) -> Void in
                self.activityIndicator.stopAnimating()
                self.refreshControl?.endRefreshing()
                self.showErrorAndSetMessage("Could not load announcements.", size: 64.0)
        }
    }
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, size: size, currentError: error)
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