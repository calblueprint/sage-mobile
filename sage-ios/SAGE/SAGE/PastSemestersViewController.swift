//
//  PastSemestersViewController.swift
//  SAGE
//
//  Created by Erica Yin on 3/6/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class PastSemestersViewController: UITableViewController {
    
    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var semesters: [Semester]?
    var previousVC: UIViewController?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Past Semesters"
        self.tableView.tableFooterView = UIView()
        self.previousVC = self
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.lightGrayColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadSemesters", forControlEvents: .ValueChanged)
        
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
    
    func showErrorAndSetMessage(message: String) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, currentError: error, color: UIColor.mainColor)
        self.currentErrorMessage = errorView
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
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Semester")
            cell!.selectionStyle = .None
            cell!.textLabel!.font = UIFont.normalFont
            cell!.detailTextLabel!.font = UIFont.normalFont
        }
        let semester = self.semesters![indexPath.row]
        cell!.textLabel!.text = semester.displayText()
        var semesterFinishDateString = "Present"
        if semester.finishDate != nil {
            semesterFinishDateString = semester.dateStringFromFinishDate()
        }
        cell!.detailTextLabel!.text = semester.dateStringFromStartDate() + " - " + semesterFinishDateString
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
