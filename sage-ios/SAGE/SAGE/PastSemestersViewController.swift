//
//  PastSemestersViewController.swift
//  SAGE
//
//  Created by Erica Yin on 3/6/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class PastSemestersViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Past Semesters"
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor
        let closeButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Semester")
        cell.selectionStyle = .None
        cell.textLabel!.text = "Spring 2016"
        cell.textLabel!.font = UIFont.normalFont
        //        cell.textLabel!.text = semesters[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}