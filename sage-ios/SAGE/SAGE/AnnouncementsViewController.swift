//
//  AnnouncementsViewController.swift
//  SAGE
//
//  Created by Erica Yin on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class AnnouncementsViewController: UIViewController {
    
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
        return 44.0
    }
}

extension AnnouncementsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableViewCell = tableView.dequeueReusableCellWithIdentifier("Announcement")
        if (tableViewCell == nil) {
            tableViewCell = UITableViewCell(style: .Default, reuseIdentifier: "Announcement")
        }
        tableViewCell!.textLabel?.text = "Ass"
        return tableViewCell!
    }
    
}