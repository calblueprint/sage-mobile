//
//  AdminTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/5/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit
import SwiftKeychainWrapper

class AdminTableViewController: SGTableViewController {

    //
    // MARK: - Initialization
    //
    override init(style: UITableViewStyle) {
        super.init(style: style)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "semesterStarted:", name: NotificationConstants.startSemesterKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "semesterEnded:", name: NotificationConstants.endSemesterKey, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: - ViewController Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Admin"
    }
    
    //
    // MARK: - NSNotificationCenter Handlers
    //
    func semesterStarted(notification: NSNotification) {
        self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Automatic)
    }
    
    func semesterEnded(notification: NSNotification) {
        self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Automatic)
    }
    
    //
    // MARK: - UITableViewDelegate
    //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if LoginOperations.getUser()?.role == .President {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 1
        default: return 0
        }
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Browse"
        case 1:
            return "Requests"
        case 2:
            return "SAGE Settings"
        default: return ""
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(BrowseMentorsViewController(), animated: true)
            case 1:
                self.navigationController?.pushViewController(BrowseSchoolsViewController(style: .Plain), animated: true)
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(CheckinRequestsViewController(), animated: true)
            case 1:
                self.navigationController?.pushViewController(SignUpRequestsViewController(style: .Plain), animated: true)
            default: break
            }
        case 2:
            switch indexPath.row {
            case 0:
                if LoginOperations.getUser()?.role == .President {
                    if let _ = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) {
                        self.presentViewController(EndSemesterViewController(), animated: true, completion: nil)
                    } else {
                        self.navigationController?.pushViewController(StartSemesterViewController(), animated: true)
                    }
                }
            default: break
            }
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // not dequeuing because there's a small, fixed number of cells
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let iconSize: CGFloat = CGFloat(23.0)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Mentors"
                let icon = FAKIonIcons.clipboardIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            } else {
                cell.textLabel?.text = "Schools"
                let icon = FAKIonIcons.homeIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            }
        case 1:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Check Ins"
                let icon = FAKIonIcons.locationIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            } else {
                cell.textLabel?.text = "Sign Ups"
                let icon = FAKIonIcons.personAddIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            }
        case 2:
            if LoginOperations.getUser()?.role == .President && indexPath.row == 0 {
                if let _ = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) {
                    cell.textLabel?.text = "End Semester"
                    let icon = FAKIonIcons.logOutIconWithSize(iconSize)
                        .imageWithSize(CGSizeMake(iconSize, iconSize))
                    cell.imageView?.image = icon
                } else {
                    cell.textLabel?.text = "Start Semester"
                    let icon = FAKIonIcons.logInIconWithSize(iconSize)
                        .imageWithSize(CGSizeMake(iconSize, iconSize))
                    cell.imageView?.image = icon
                }
            }
            default: break
        }
        cell.textLabel?.font = UIFont.normalFont
        return cell
    }
}
