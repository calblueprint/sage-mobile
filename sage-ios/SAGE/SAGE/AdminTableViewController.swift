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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AdminTableViewController.semesterStarted(_:)), name: NotificationConstants.startSemesterKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AdminTableViewController.semesterEnded(_:)), name: NotificationConstants.endSemesterKey, object: nil)
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
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.mainColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Admin")
    }
    
    //
    // MARK: - NSNotificationCenter Handlers
    //
    func semesterStarted(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    func semesterEnded(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    //
    // MARK: - UITableViewDelegate
    //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if LoginOperations.getUser()?.role == .President {
            return 4
        } else {
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
        // No need to account for if the user is a President for showing the Pause Semester
        // since this section doesn't show at all for non-Presidents
        case 3:
            if let currentSemester = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) as? Semester {
                if !currentSemester.isPaused {
                    return 2
                }
            }
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
            return "History"
        case 3:
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
                self.navigationController?.pushViewController(PastSemestersViewController(), animated: true)
            case 1:
                self.navigationController?.pushViewController(ExportSemesterViewController(), animated: true)
            default: break
            }
        case 3:
            switch indexPath.row {
            case 0:
                if let _ = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) {
                    self.presentViewController(EndSemesterViewController(), animated: true, completion: nil)
                } else {
                    self.navigationController?.pushViewController(StartSemesterViewController(), animated: true)
                }
            case 1:
                let pauseSemesterVC = PauseSemesterViewController()
                pauseSemesterVC.presentingNavigationController = self.navigationController
                self.presentViewController(pauseSemesterVC, animated: true, completion: nil)
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
            if indexPath.row == 0 {
                cell.textLabel?.text = "Past Semesters"
                let icon = FAKIonIcons.androidTimeIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            } else {
                cell.textLabel?.text = "Export Semester"
                let icon = FAKIonIcons.shareIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            }
        case 3:
            if indexPath.row == 0 {
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
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Pause Hours"
                let icon = FAKIonIcons.minusCircledIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            }
        default: break
        }
        cell.textLabel?.font = UIFont.normalFont
        return cell
    }
}
