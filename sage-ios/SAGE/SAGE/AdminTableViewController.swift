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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 2
        case 3:
            return 2
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Mentors"
        case 1:
            return "Schools"
        case 2:
            return "Requests"
        case 3:
            return "SAGE Settings"
        default: return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // not dequeuing because there's a small, fixed number of cells
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Browse"
            let icon = FAKIonIcons.clipboardIconWithSize(UIConstants.tabBarIconSize)
                .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
            cell.imageView?.image = icon
        case 1:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Browse"
                let icon = FAKIonIcons.homeIconWithSize(UIConstants.tabBarIconSize)
                    .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
                cell.imageView?.image = icon
            } else {
                cell.textLabel?.text = "Add"
                let icon = FAKIonIcons.plusIconWithSize(UIConstants.tabBarIconSize)
                    .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
                cell.imageView?.image = icon
            }
        case 2:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Check ins"
                let icon = FAKIonIcons.locationIconWithSize(UIConstants.tabBarIconSize)
                    .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
                cell.imageView?.image = icon
            } else {
                cell.textLabel?.text = "Sign ups"
                let icon = FAKIonIcons.personAddIconWithSize(UIConstants.tabBarIconSize)
                    .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
                cell.imageView?.image = icon
            }
        case 3:
            if indexPath.row == 0 {
                cell.textLabel?.text = "End Fall 2015"
                let icon = FAKIonIcons.arrowRightAIconWithSize(UIConstants.tabBarIconSize)
                    .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
                cell.imageView?.image = icon
            } else {
                cell.textLabel?.text = "Change hour requirements"
                let icon = FAKIonIcons.clockIconWithSize(UIConstants.tabBarIconSize)
                    .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
                cell.imageView?.image = icon
            }
        default: break
        }
        return cell
    }
}
