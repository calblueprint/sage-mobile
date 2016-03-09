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
    
//    deinit {
//        UIView.animateWithDuration(UIConstants.fastAnimationTime) { () -> Void in
//            self.previousVC?.navigationController?.navigationBar.barTintColor = UIColor.mainColor
//        }
//    }
    
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
        if let _ = self.semesters {
            let semesterID = self.semesters![indexPath.row].id
            let vc = BrowseMentorsViewController()
            vc.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor
            if let topItem = self.navigationController!.navigationBar.topItem {
                topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            }
            vc.filter = [SemesterConstants.kSemesterId: String(semesterID)]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
