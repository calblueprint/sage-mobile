//
//  PastSemestersViewController.swift
//  SAGE
//
//  Created by Erica Yin on 3/6/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class PastSemestersViewController: SGTableViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var semesters: [Semester]?
    weak var previousVC: UIViewController?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Past Semesters")
        self.tableView.tableFooterView = UIView()
        self.previousVC = self
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.lightGrayColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(PastSemestersViewController.loadSemesters), forControlEvents: .ValueChanged)
        
        self.loadSemesters()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.activityIndicator.centerInSuperview()
    }
    
    func loadSemesters() {
        SemesterOperations.loadSemesters({ (semestersArray) -> Void in
            self.semesters = semestersArray
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()
            }) { (errorMessage) -> Void in
                self.activityIndicator.stopAnimating()
                self.refreshControl?.endRefreshing()
                self.showErrorAndSetMessage(errorMessage)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52.0
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
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Semester")
            cell!.selectionStyle = .None
            cell!.textLabel!.font = UIFont.semiboldFont
            cell!.detailTextLabel!.font = UIFont.normalFont
            cell!.detailTextLabel!.textColor = UIColor.secondaryTextColor
        }
        let semester = self.semesters![indexPath.row]
        cell!.textLabel!.text = semester.displayText()
        cell!.detailTextLabel!.text = semester.dateStringFromStartDate() + " - " + semester.dateStringFromFinishDate()
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.semesters {
            let semesterID = self.semesters![indexPath.row].id
            let vc = BrowseMentorsViewController()
            vc.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor
            vc.filter = [SemesterConstants.kSemesterId: String(semesterID)]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
