//
//  SchoolDetailViewController
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SchoolDetailViewController: UITableViewController {
    
    private var schoolDetailHeaderView: SchoolDetailHeaderView = SchoolDetailHeaderView()
    private var school: School?
    
    func configureWithSchool(school: School) {
        self.title = school.name!
        AdminOperations.loadSchool(school.id, completion: { (updatedSchool) -> Void in
            self.configureWithCompleteSchool(updatedSchool)
            }) { (message) -> Void in }
    }
    
    private func configureWithCompleteSchool(school: School) {
        self.school = school
        let marker = GMSMarker(position: self.school!.location!.coordinate)
        marker.map = self.schoolDetailHeaderView.mapView
        self.schoolDetailHeaderView.mapView.camera = GMSCameraPosition(target: self.school!.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
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
                if let _ = self.school?.director {
                    return 1
                } else {
                    return 0
                }
            } else {
                if let students = school.students {
                    return students.count
                } else {
                    return 0
                }
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
            cell = UsersTableViewCell(style: .Default, reuseIdentifier: "BrowseMentorsCell")
        }
        if indexPath.section == 0 {
            (cell as! UsersTableViewCell).configureWithUser(self.school!.director!)
        } else {
            (cell as! UsersTableViewCell).configureWithUser(self.school!.students![indexPath.row])
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UsersTableViewCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Director"
        } else {
            return "Students"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = self.school?.director {
            return UITableViewAutomaticDimension
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var userProfile: User
        if indexPath.section == 0 {
            userProfile = self.school!.director!
        } else {
            userProfile = self.school!.students![indexPath.row]
        }
        let viewController = ProfileViewController(user: userProfile)
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    
}
