//
//  AnnouncementsViewController.swift
//  SAGE
//
//  Created by Erica Yin on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class AnnouncementsViewController: UIViewController {
    
    var announcements: [Announcement] = [
        Announcement(sender: User(firstName: "Charles", lastName: "Xue"), title: "Announcement Title", text: "Here's a short announcement.", timeCreated: NSDate()),
        Announcement(sender: User(firstName: "Andrew", lastName: "Millman"), title: "Another Announcement Title", text: "Here's a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, long announcement.", timeCreated: NSDate())]
    
    override func loadView() {
        self.view = AnnouncementsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Announcements"
        (self.view as! AnnouncementsView).tableView.delegate = self
        (self.view as! AnnouncementsView).tableView.dataSource = self
    }
    
}

extension AnnouncementsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AnnouncementsTableViewCell.heightForAnnouncement(announcements[indexPath.row], width: CGRectGetWidth(tableView.frame))
    }
}

extension AnnouncementsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Announcement")
        if (cell == nil) {
            cell = AnnouncementsTableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Announcement")
        }
        let announcementsCell = cell as! AnnouncementsTableViewCell
        announcementsCell.setupWithAnnouncement(announcements[indexPath.row])
        return announcementsCell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        NSLog("selected cell at row: \(indexPath.row)")
        var view = AnnouncementsDetailViewController(announcement: self.announcements[indexPath.row])
        self.navigationController!.pushViewController(view, animated: true)
    }
}