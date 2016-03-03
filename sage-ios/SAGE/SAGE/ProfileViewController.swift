//
//  ProfileViewController.swift
//  SAGE
//
//  Created by Erica Yin on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class ProfileViewController: SGTableViewController {

    var user: User?
    var profileView = ProfileView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var currentErrorMessage: ErrorView?
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "editedProfile:", name: NotificationConstants.editProfileKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "schoolEdited:", name: NotificationConstants.editSchoolKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "verifiedCheckinAdded:", name: NotificationConstants.addVerifiedCheckinKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "semesterJoined:", name: NotificationConstants.joinSemesterKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "semesterEnded:", name: NotificationConstants.endSemesterKey, object: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.user = User()
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: - NSNotificationCenter selectors
    //
    func editedProfile(notification: NSNotification) {
        let newUser = notification.object!.copy() as! User
        if self.user?.id == newUser.id {
            self.user = newUser
            self.profileView.setupWithUser(newUser)
            self.tableView.reloadData()
        }
    }
    
    func schoolEdited(notification: NSNotification) {
        let school = notification.object!.copy() as! School
        if self.user?.school?.id == school.id {
            self.user?.school = school
            self.profileView.setupWithUser(self.user!)
        }
    }

    func verifiedCheckinAdded(notification: NSNotification) {
        let checkin = notification.object!.copy() as! Checkin
        if LoginOperations.getUser()?.id == checkin.user?.id {
            self.user?.semesterSummary?.totalMinutes += checkin.minuteDuration()
            self.profileView.setupWithUser(self.user!)
            self.tableView.reloadData()
        }

    }
    
    func semesterJoined(notification: NSNotification) {
        let summary = notification.object!.copy() as! SemesterSummary
        if LoginOperations.getUser()?.id == self.user?.id {
            self.user?.semesterSummary = summary
            self.profileView.setupWithUser(self.user!)
            self.tableView.reloadData()
        }
        
    }
    
    func semesterEnded(notification: NSNotification) {
        self.user?.semesterSummary = nil
        self.profileView.setupWithUser(self.user!)
        self.tableView.reloadData()
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
        self.activityIndicator.setY(self.profileView.headerHeight + CGFloat(40))
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "getUser", forControlEvents: .ValueChanged)
        self.view.bringSubviewToFront(self.refreshControl!)
        
        self.getUser()
    }
    
    func promote() {
        if self.user?.role == .Volunteer {
            var message = "Promote user to:"
            if self.user != nil && self.user?.firstName != nil && self.user?.lastName != nil {
                message = "Promote " + self.user!.fullName() + " to:"
            }
            let alertController = UIAlertController(title: "Promote", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let adminAction = UIAlertAction(title: "Admin", style: .Default) { (action) -> Void in
                self.sendChangeRoleRequest(.Admin)
            }
            let presidentAction = UIAlertAction(title: "President", style: .Default) { (action) -> Void in
                self.sendChangeRoleRequest(.President)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(adminAction)
            alertController.addAction(presidentAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            var message: String
            message = "Promote user to president?"
            if self.user != nil && self.user?.firstName != nil && self.user?.lastName != nil {
                message = "Promote " + self.user!.fullName() + " to president?"
            }
            
            let alertController = UIAlertController(title: "Promote", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                self.sendChangeRoleRequest(.President)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func sendChangeRoleRequest(role: User.UserRole) {
        self.profileView.startPromoting()
        ProfileOperations.promote(self.user!, role: role, completion: { (updatedUser) -> Void in
            if role == .President {
                let existingUser = LoginOperations.updateUserRoleInKeychain(.Admin)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editProfileKey, object: existingUser)
            }
            self.user = updatedUser
            self.profileView.setupWithUser(updatedUser)
            self.profileView.promoteButton.stopLoading()
            }, failure: { (message) -> Void in
                self.showErrorAndSetMessage(message)
        })
    }
    
    func demote() {
        var message = "Do you want to demote this user?"
        if self.user != nil && self.user?.firstName != nil && self.user?.lastName != nil {
            message = "Do you want to demote " + self.user!.fullName() + "?"
        }
        let alertController = UIAlertController(title: "Demote", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            self.profileView.startDemoting()
            ProfileOperations.demote(self.user!, completion: { (updatedUser) -> Void in
                self.user = updatedUser
                self.profileView.setupWithUser(updatedUser)
                self.profileView.demoteButton.stopLoading()

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
            self.user = user

            
            self.profileView.setupWithUser(user)
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()
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
        editProfileController.editProfileView.photoView.image = self.profileView.profileUserImg.image().copy() as? UIImage
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
        } else if LoginOperations.getUser()!.role == .Admin || LoginOperations.getUser()!.role == .President {
            return 1
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let view = ProfileCheckinViewController(user: self.user)
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
