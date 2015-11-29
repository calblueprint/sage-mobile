//
//  BrowseSchoolsDetailViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseSchoolsDetailViewController: UITableViewController {

    var schoolDetailHeaderView: SchoolDetailHeaderView = SchoolDetailHeaderView()
    var school: School?
    
    func configureWithSchool(school: School) {
        self.title = school.name!
        self.school = school
        
        let marker = GMSMarker(position: self.school!.location!.coordinate)
        marker.map = self.schoolDetailHeaderView.mapView
        self.schoolDetailHeaderView.mapView.moveCamera(GMSCameraUpdate.setTarget(self.school!.location!.coordinate))
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.schoolDetailHeaderView.layoutSubviews()
        self.tableView.tableHeaderView = schoolDetailHeaderView
        self.tableView.tableFooterView = UIView()
        
        if let coordinate = self.school?.location?.coordinate {
            let marker = GMSMarker(position: coordinate)
            marker.map = self.schoolDetailHeaderView.mapView
            self.schoolDetailHeaderView.mapView.moveCamera(GMSCameraUpdate.setTarget(coordinate))
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let school = self.school {
            if section == 0 {
                return 1
            } else {
                return school.students!.count
            }
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("BrowseMentorsCell")
        if cell == nil {
            cell = BrowseMentorsTableViewCell(style: .Default, reuseIdentifier: "BrowseMentorsCell")
        }
        if indexPath.section == 0 {
            (cell as! BrowseMentorsTableViewCell).configureWithUser(self.school!.director!)
        } else {
            (cell as! BrowseMentorsTableViewCell).configureWithUser(self.school!.students![indexPath.row])
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return BrowseMentorsTableViewCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Director"
        } else {
            return "Students"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = self.school {
            return UITableViewAutomaticDimension
        } else {
            return 0
        }
    }

}
