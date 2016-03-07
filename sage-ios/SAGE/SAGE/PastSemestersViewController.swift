//
//  PastSemestersViewController.swift
//  SAGE
//
//  Created by Erica Yin on 3/6/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class PastSemestersViewController: UITableViewController {
    
    var semesters: [Semester]?
    var previousVC: UIViewController?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Past Semesters"
        self.tableView.tableFooterView = UIView()
        let n: Int! = self.navigationController?.viewControllers.count
        self.previousVC = self.navigationController!.viewControllers[n-2]
        self.loadSemesters()
    }
    
    func loadSemesters() {
        SemesterOperations.loadSemesters({ (semestersArray) -> Void in
            self.semesters = semestersArray
            self.tableView.reloadData()
            }) { (errorMessage) -> Void in
                // ok later
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.previousVC?.navigationController?.navigationBar.barTintColor = UIColor.mainColor
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let semesters = self.semesters {
            return semesters.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Semester")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Semester")
        }
        cell!.selectionStyle = .None
        cell!.textLabel!.text = self.semesters![indexPath.row].displayText()
        cell!.textLabel!.font = UIFont.normalFont
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
