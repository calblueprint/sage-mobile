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
    var schoolLocation:  CLLocation?
    var director: User?
    var students: [User] = [User]()
    
    func configureWithSchool(school: School) {
        self.title = school.name!
        self.schoolLocation = school.location!
        self.schoolDetailHeaderView.schoolName.text = school.name!
        self.schoolDetailHeaderView.directorName.text = "director name"
        self.schoolDetailHeaderView.studentsList.text = "some studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome students"
        self.director = school.director
        if let students = school.students {
            self.students.appendContentsOf(students)
        }
    }

    override func viewDidLoad() {
        self.schoolDetailHeaderView.layoutSubviews()
        super.viewDidLoad()
        self.tableView.tableHeaderView = schoolDetailHeaderView
        
        //self.tableView.tableFooterView = UIView()
        let marker = GMSMarker(position: self.schoolLocation!.coordinate)
        marker.map = self.schoolDetailHeaderView.mapView
        self.schoolDetailHeaderView.mapView.moveCamera(GMSCameraUpdate.setTarget(self.schoolLocation!.coordinate))
        // Do any additional setup after loading the view.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        if self.director != nil && self.students.count > 0{
            return 2
        } else if self.director != nil || self.students.count > 0 {
            return 1
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "StudentsCell")
        if indexPath.section == 0 {
            cell.textLabel?.text = self.director!.fullName()
        } else {
            cell.textLabel?.text = self.students[indexPath.row].fullName()
        }
        cell.textLabel?.font = UIFont.getDefaultFont()
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Director"
        } else {
            return "Students"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if let _ = self.director {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        } else {
            if self.students.count > 0 {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        }
    }

}
