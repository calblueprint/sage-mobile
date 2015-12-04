//
//  ProfileViewController.swift
//  SAGE
//
//  Created by Erica Yin on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class ProfileViewController: UITableViewController {

    var currentUser = User()
    var profileView = ProfileView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        self.tableView.tableHeaderView = self.profileView
        let headerOffset = self.profileView.viewHeight + CGFloat(40)
        var headerFrame = self.tableView.tableHeaderView!.frame
        headerFrame.size.height = headerOffset
        self.profileView.frame = headerFrame
        self.tableView.tableHeaderView = self.profileView
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
        self.activityIndicator.startAnimating()
        
        self.getUser()
    }
    
    func getUser() {
        ProfileOperations.getUser({ (user) -> Void in
            self.currentUser = user
            self.profileView.setupWithUser(user)
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()

            }) { (errorMessage) -> Void in
                //display error
        }
    }
        
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.selectionStyle = .None
        cell.textLabel!.font = UIFont.normalFont
        if indexPath.section == 0 {
            cell.textLabel!.text = "All Check Ins"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else if indexPath.section == 1 {
            cell.textLabel!.text = "Log Out"
            cell.textLabel?.textColor = UIColor.redColor()
            cell.textLabel!.textAlignment = NSTextAlignment.Center
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let view = AnnouncementsViewController()
            self.navigationController!.pushViewController(view, animated: true)
        } else if indexPath.section == 1 {
            LoginOperations.deleteUserKeychainData()
            let view = RootController()
            self.presentViewController(view, animated: true, completion: nil)
        }
    }
    
}
