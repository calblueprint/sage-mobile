//
//  AdminTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/5/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class AdminTableViewController: UITableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Admin"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
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
                self.navigationController?.pushViewController(SignUpRequestsViewController(), animated: true)
            default: break
            }
        case 2:
            switch indexPath.row {
            case 0:
                if false { //if semester exists
                    self.presentViewController(EndSemesterViewController(), animated: true, completion: nil)
                } else {
                    self.navigationController?.pushViewController(StartSemesterViewController(), animated: true)
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
                cell.textLabel?.text = "Check ins"
                let icon = FAKIonIcons.locationIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            } else {
                cell.textLabel?.text = "Sign ups"
                let icon = FAKIonIcons.personAddIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            }
        case 2:
            if indexPath.row == 0 {
                if false { // if semester exists
                    cell.textLabel?.text = "End Fall 2015"
                    let icon = FAKIonIcons.logOutIconWithSize(iconSize)
                        .imageWithSize(CGSizeMake(iconSize, iconSize))
                    cell.imageView?.image = icon
                } else {
                    cell.textLabel?.text = "Start new semester"
                    let icon = FAKIonIcons.logInIconWithSize(iconSize)
                        .imageWithSize(CGSizeMake(iconSize, iconSize))
                    cell.imageView?.image = icon
                }
            } else {
                cell.textLabel?.text = "Change hour requirements"
                let icon = FAKIonIcons.clockIconWithSize(iconSize)
                    .imageWithSize(CGSizeMake(iconSize, iconSize))
                cell.imageView?.image = icon
            }
        default: break
        }
        cell.textLabel?.font = UIFont.normalFont
        return cell
    }
}
