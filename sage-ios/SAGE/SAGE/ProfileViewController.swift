//
//  ProfileViewController.swift
//  SAGE
//
//  Created by Erica Yin on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class ProfileViewController: UITableViewController {

    var user: User?
    var profileView = ProfileView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var currentErrorMessage: ErrorView?
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "editedProfile:", name: NotificationConstants.editProfileKey, object: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        self.user = User()
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: - NSNotificationCenter selectors
    //
    func editedProfile(notification: NSNotification) {
        let user = notification.object!.copy() as! User
        if LoginOperations.getUser()!.id == user.id {
            LoginOperations.storeUserDataInKeychain(user)
            self.profileView.setupWithUser(user)
            self.tableView.reloadData()
        }
    }
    
    func setupHeader() {
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        self.tableView.tableHeaderView = self.profileView
        let headerOffset = self.profileView.viewHeight + CGFloat(40)
        var headerFrame = self.tableView.tableHeaderView!.frame
        headerFrame.size.height = headerOffset
        self.profileView.frame = headerFrame
        self.tableView.tableHeaderView = self.profileView
        self.profileView.profileEditButton.addTarget(self, action: "editProfile", forControlEvents: .TouchUpInside)
        self.profileView.promoteButton.addTarget(self, action: "promote", forControlEvents: .TouchUpInside)
        self.profileView.demoteButton.addTarget(self, action: "demote", forControlEvents: .TouchUpInside)
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
    
    func promote() {
        var message = "Do you want to promote this user?"
        if self.user != nil && self.user?.firstName != nil && self.user?.lastName != nil {
            message = "Do you want to promote " + self.user!.fullName() + "?"
        }
        let alertController = UIAlertController(title: "Promote", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            self.profileView.startActivityIndicator()
            ProfileOperations.promote(self.user!, completion: { () -> Void in
                    self.profileView.didPromote()
                }, failure: { (message) -> Void in
                    self.showErrorAndSetMessage(message)
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func demote() {
        var message = "Do you want to demote this user?"
        if self.user != nil && self.user?.firstName != nil && self.user?.lastName != nil {
            message = "Do you want to demote " + self.user!.fullName() + "?"
        }
        let alertController = UIAlertController(title: "Demote", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            self.profileView.startActivityIndicator()
            ProfileOperations.demote(self.user!, completion: { () -> Void in
                self.profileView.didDemote()
                }, failure: { (message) -> Void in
                    self.showErrorAndSetMessage(message)
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getUser() {
        ProfileOperations.getUser(self.user!, completion: { (user) -> Void in
            
            if LoginOperations.getUser()!.id == user.id {
                self.profileView.currentUserProfile = true
            } else {
                self.profileView.currentUserProfile = false
            }
            
            if LoginOperations.getUser()!.role == .Admin && LoginOperations.getUser()!.id != user.id  {
                if user.role == .Admin {
                    self.profileView.canPromote = false
                    self.profileView.canDemote = true
                } else {
                    self.profileView.canPromote = true
                    self.profileView.canDemote = false

                }
            } else {
                self.profileView.canPromote = false
                self.profileView.canDemote = false
            }
            
            self.profileView.setupWithUser(user)
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            }) { (errorMessage) -> Void in
                self.activityIndicator.stopAnimating()
                self.refreshControl?.endRefreshing()
                self.showErrorAndSetMessage("Could not load profile.")
        }
    }
    
    func editProfile() {
        let editProfileController = EditProfileController(user: self.user!.copy() as! User)
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(editProfileController, animated: true)
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

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let viewOffset = scrollView.contentOffset.y
        self.profileView.adjustToScroll(viewOffset)
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

            let logoutAlert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .ActionSheet)
            
            let logoutAction = UIAlertAction(title: "Log Out", style: .Destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                let rootController = RootController()
                LoginOperations.deleteUserKeychainData()
                self.presentViewController(rootController, animated: true, completion: nil)
            })
                
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            
            logoutAlert.addAction(logoutAction)
            logoutAlert.addAction(cancelAction)
            
            self.presentViewController(logoutAlert, animated: true, completion: nil)
                
        }
    }
    
}
