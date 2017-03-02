//
//  ProfileViewController.swift
//  SAGE
//
//  Created by Erica Yin on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import UserNotifications

class ProfileViewController: SGTableViewController {

    var user: User?
    var isCurrentUserProfile: Bool = true
    var profileView = ProfileView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var notificationSwitch = UISwitch()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.editedProfile(_:)), name: NotificationConstants.editProfileKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.schoolEdited(_:)), name: NotificationConstants.editSchoolKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.verifiedCheckinAdded(_:)), name: NotificationConstants.addVerifiedCheckinKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.semesterJoined(_:)), name: NotificationConstants.joinSemesterKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.semesterEnded(_:)), name: NotificationConstants.endSemesterKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.refreshViewState), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.user = User()
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refreshViewState()
    }
    
    //
    // MARK: - NSNotificationCenter selectors
    //
    func editedProfile(notification: NSNotification) {
        let newUser = notification.object!.copy() as! User
        if self.user?.id == newUser.id {
            self.user = newUser
            self.profileView.setupWithUser(newUser, pastSemester: self.filter != nil)
            self.tableView.reloadData()
        }
    }
    
    func schoolEdited(notification: NSNotification) {
        let school = notification.object!.copy() as! School
        if self.user?.school?.id == school.id {
            self.user?.school = school
            self.profileView.setupWithUser(self.user!, pastSemester: self.filter != nil)
        }
    }

    func verifiedCheckinAdded(notification: NSNotification) {
        let checkin = notification.object!.copy() as! Checkin
        if SAGEState.currentUser()?.id == checkin.user?.id {
            self.user?.semesterSummary?.totalMinutes += checkin.minuteDuration()
            self.profileView.setupWithUser(self.user!, pastSemester: self.filter != nil)
            self.tableView.reloadData()
        }

    }
    
    func semesterJoined(notification: NSNotification) {
        let summary = notification.object!.copy() as! SemesterSummary
        if SAGEState.currentUser()?.id == self.user?.id {
            self.user?.semesterSummary = summary
            self.profileView.setupWithUser(self.user!, pastSemester: self.filter != nil)
            self.tableView.reloadData()
        }
        
    }
    
    func semesterEnded(notification: NSNotification) {
        self.user?.semesterSummary = nil
        self.profileView.setupWithUser(self.user!, pastSemester: self.filter != nil)
        self.tableView.reloadData()
    }
    
    func refreshViewState() {
        UserAuthorization.setUserNotificationSwitchState(self.notificationSwitch)
        self.notificationSwitch.enabled = UserAuthorization.userNotificationSwitchEnabled()
    }
    
    func setupHeader() {
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        self.tableView.tableHeaderView = self.profileView
        let headerOffset = self.profileView.viewHeight + CGFloat(40)
        var headerFrame = self.tableView.tableHeaderView!.frame
        headerFrame.size.height = headerOffset
        self.profileView.frame = headerFrame
        self.tableView.tableHeaderView = self.profileView
        self.profileView.profileEditButton.addTarget(self, action: #selector(ProfileViewController.editProfile), forControlEvents: .TouchUpInside)
        self.profileView.promoteButton.addTarget(self, action: #selector(ProfileViewController.promote), forControlEvents: .TouchUpInside)
        self.profileView.demoteButton.addTarget(self, action: #selector(ProfileViewController.demote), forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHeader()
        self.tableView.tableFooterView = UIView()
        self.isCurrentUserProfile = self.user!.id == SAGEState.currentUser()!.id
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.setY(self.profileView.headerHeight + CGFloat(40))
        self.activityIndicator.startAnimating()
        
        if self.filter != nil {
            self.refreshControl?.backgroundColor = UIColor.lightGrayColor
            self.profileView.setHeaderBackgroundColor(UIColor.lightGrayColor)
        } else {
            self.refreshControl?.backgroundColor = UIColor.mainColor
            self.profileView.setHeaderBackgroundColor(UIColor.mainColor)
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(ProfileViewController.getUser), forControlEvents: .ValueChanged)
        self.view.bringSubviewToFront(self.refreshControl!)
        
        self.notificationSwitch.onTintColor = UIColor.mainColor
        UserAuthorization.setUserNotificationSwitchState(self.notificationSwitch)
        self.notificationSwitch.enabled = UserAuthorization.userNotificationAllowed()
        self.notificationSwitch.addTarget(self, action: #selector(notificationSwitchAction), forControlEvents: .ValueChanged)
        
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
                let currentUser = SAGEState.currentUser()!
                currentUser.role = .Admin
                SAGEState.setCurrentUser(currentUser)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editProfileKey, object: currentUser)
            }
            self.user = updatedUser
            self.profileView.setupWithUser(updatedUser, pastSemester: self.filter != nil)
            self.profileView.promoteButton.stopLoading()
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editProfileKey, object: updatedUser)
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
                self.profileView.setupWithUser(updatedUser, pastSemester: self.filter != nil)
                self.profileView.demoteButton.stopLoading()
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editProfileKey, object: updatedUser)

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
        ProfileOperations.getUser(filter: self.filter, user: self.user!, completion: { (user) -> Void in
            self.user = user
            self.profileView.setupWithUser(user, pastSemester: self.filter != nil)
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
        editProfileController.editProfileView.photoView.image = self.profileView.profileUserImg.image().copy() as? UIImage
        self.navigationController?.pushViewController(editProfileController, animated: true)
    }
    
    @objc func notificationSwitchAction(sender: UISwitch) {
        SAGEState.setLocationNotification(sender.on)
        if (sender.on) {
            UserAuthorization.userNotificationCheckAuthorization(presentingViewController: self, settingSwitch: notificationSwitch)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 && self.isCurrentUserProfile {
            return 64.0
        }
        return 44.0
    }
        
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.isCurrentUserProfile && self.filter == nil {
            return 2
        } else if (SAGEState.currentUser()!.role == .Admin || SAGEState.currentUser()!.role == .President) {
            return 1
        }
        return 0
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let viewOffset = scrollView.contentOffset.y
        self.profileView.adjustToScroll(viewOffset)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.isCurrentUserProfile {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == 0 {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
            cell.selectionStyle = .None
            cell.textLabel!.font = UIFont.normalFont
            if (indexPath.row == 0) {
                cell.textLabel!.text = "All Check Ins"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                cell.textLabel!.text = "Location Notifications"
                cell.detailTextLabel!.adjustsFontSizeToFitWidth = true
                cell.detailTextLabel!.numberOfLines = 2
                cell.detailTextLabel!.text = "We'll remind you to check in when you're near \(user?.getValidSchoolString() ?? "your school")."
                cell.accessoryView = notificationSwitch
            }
        } else {
            cell = UITableViewCell()
            cell.selectionStyle = .None
            cell.textLabel!.font = UIFont.normalFont
            cell.textLabel!.text = "Log Out"
            cell.textLabel?.textColor = UIColor.redColor()
            cell.textLabel!.textAlignment = .Center
        }
        return cell
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 1 {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let vc = ProfileCheckinViewController(user: self.user)
            vc.filter = self.filter
            self.navigationController!.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {

            let logoutAlert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .ActionSheet)
            
            let logoutAction = UIAlertAction(title: "Log Out", style: .Destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                SAGEState.reset()
                RootController.sharedController().pushCorrectViewController()
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
