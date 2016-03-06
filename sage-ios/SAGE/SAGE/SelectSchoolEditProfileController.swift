//
//  SelectSchoolEditProfileController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SelectSchoolEditProfileController: SelectAnnouncementSchoolTableViewController {

    weak var parentVCEditProfile: EditProfileController?
    
    override func loadSchools() {
        AdminOperations.loadSchools({ (schoolArray) -> Void in
            self.schools = schoolArray
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()
            
            if self.schools?.count == 0 {
                self.showNoContentView()
            } else {
                self.hideNoContentView()
            }
            
            }) { (errorMessage) -> Void in
                self.showNoContentView()
                self.showErrorAndSetMessage(errorMessage)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.parentVCEditProfile?.didSelectSchool(self.schools![indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
}
