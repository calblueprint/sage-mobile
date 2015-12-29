//
//  ProfileViewController.swift
//  SAGE
//
//  Created by Erica Yin on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class ProfileViewController: UITableViewController {

    var user: User?
    var profileView = ProfileView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var currentErrorMessage: ErrorView?
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.user = User()
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeader() {
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        self.tableView.tableHeaderView = self.profileView
        let headerOffset = self.profileView.viewHeight + CGFloat(40)
        var headerFrame = self.tableView.tableHeaderView!.frame
        headerFrame.size.height = headerOffset
        self.profileView.frame = headerFrame
        self.tableView.tableHeaderView = self.profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHeader()
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.setY(self.profileView.headerHeight + CGFloat(65))
        self.activityIndicator.startAnimating()
        
        self.getUser()
    }
    
    func getUser() {
        ProfileOperations.getUser(self.user!, completion: { (user) -> Void in
            self.profileView.setupWithUser(user)
            self.activityIndicator.stopAnimating()
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
        return 44.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if LoginOperations.getUser()!.id == self.user!.id {
            return 2
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .None
        cell.textLabel!.font = UIFont.normalFont
        if indexPath.section == 0 {
            cell.textLabel!.text = "All Check Ins"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else if indexPath.section == 1 {
            cell.textLabel!.text = "Log Out"
            cell.textLabel?.textColor = UIColor.redColor()
            cell.textLabel!.textAlignment = .Center
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let view = ProfileCheckinViewController()
            self.navigationController!.pushViewController(view, animated: true)
        } else if indexPath.section == 1 {
//            let confirmLogoutAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
//            
//            confirmLogoutAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
//                // do nothing
//            }))
//            
//            confirmLogoutAlert.addAction(UIAlertAction(title: "Log Out", style: .Cancel, handler: { (action: UIAlertAction!) in
//                LoginOperations.deleteUserKeychainData()
//                let view = RootController()
//                self.presentViewController(view, animated: true, completion: nil)
//            }))
//            
//            self.presentViewController(confirmLogoutAlert, animated: true, completion: nil)
            

            let optionMenu = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .ActionSheet)
            
            let logoutAction = UIAlertAction(title: "Log Out", style: .Destructive, handler: {
                (alert: UIAlertAction!) -> Void in
            })
                
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            
            optionMenu.addAction(logoutAction)
            optionMenu.addAction(cancelAction)
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
                
        }
    }
    
}
