//
//  SchoolDetailViewController
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SchoolDetailViewController: SGTableViewController {
    
    private var schoolDetailHeaderView: SchoolDetailHeaderView = SchoolDetailHeaderView()
    private var school: School?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    
    // MARK: - Initialization
    //
    init() {
        super.init(nibName: nil, bundle: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SchoolDetailViewController.schoolEdited(_:)), name: NotificationConstants.editSchoolKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SchoolDetailViewController.editedProfile(_:)), name: NotificationConstants.editProfileKey, object: nil)
        self.setNoContentMessage("School could not be loaded.")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func editedProfile(notification: NSNotification) {
        let newUser = notification.object!.copy() as! User
        if let school = self.school {

            if newUser.id == school.director?.id {
                school.director = newUser
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
            }
            if var students = school.students {
                for index in 0..<students.count {
                    let student = students[index]
                    if student.id == newUser.id {
                        self.school!.students![index] = newUser
                        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: .Automatic)
                    }
                }
            }
        }
    }

    //
    // MARK: - Configuration
    //
    func configureWithSchool(school: School) {
        self.changeTitle(school.name!)
        AdminOperations.loadSchool(school.id, completion: { (updatedSchool) -> Void in
            self.hideNoContentView()
            self.configureWithCompleteSchool(updatedSchool)
            self.activityIndicator.stopAnimating()
            self.schoolDetailHeaderView.mapView.hidden = false
            self.refreshControl?.endRefreshing()

            }) { (message) -> Void in
                self.showNoContentView()
        }
    }
    
    private func configureWithCompleteSchool(school: School) {
        self.school = school
        self.schoolDetailHeaderView.mapView.clear()
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
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()

        if let role = LoginOperations.getUser()?.role {
            if role == .Admin || role == .President {
                let editIcon = FAKIonIcons.androidCreateIconWithSize(UIConstants.barbuttonIconSize)
                editIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
                let editIconImage = editIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
                let rightButton = UIBarButtonItem(image: editIconImage, style: .Plain, target: self, action: #selector(SchoolDetailViewController.editSchool))
                self.navigationItem.rightBarButtonItem = rightButton

            }
        }
        
        if let coordinate = self.school?.location?.coordinate {
            let marker = GMSMarker(position: coordinate)
            marker.map = self.schoolDetailHeaderView.mapView
            self.schoolDetailHeaderView.mapView.moveCamera(GMSCameraUpdate.setTarget(coordinate))
        }

        self.schoolDetailHeaderView.mapView.hidden = true
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(SchoolDetailViewController.reload), forControlEvents: .ValueChanged)
    }
    
    func reload() {
        self.configureWithSchool(self.school!)
    }

    override func viewWillLayoutSubviews() {
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }
    
    func editSchool() {
        let editSchoolController = EditSchoolController()
        editSchoolController.configureWithSchool(self.school)
        self.navigationController?.pushViewController(editSchoolController, animated: true)
    }
    
    //
    // MARK: - Notifications
    //
    func schoolEdited(notification: NSNotification) {
        let newSchool = notification.object!.copy() as! School
        if newSchool.id == self.school!.id {
            self.school = newSchool
            self.configureWithCompleteSchool(newSchool)
            self.changeTitle(newSchool.name)
            self.tableView.reloadData()
        }
    }
    
    //
    // MARK: - UITableViewDelegate
    //
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = self.school?.director {
            return SGSectionHeaderView.sectionHeight
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SGSectionHeaderView()
        var title = ""
        if section == 0 {
            title = "Director"
        } else {
            title = "Students"
        }
        view.setSectionTitle(title)
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var userProfile: User
        if let role = LoginOperations.getUser()?.role {
            if role == .Admin || role == .President {
                if indexPath.section == 0 {
                    userProfile = self.school!.director!
                } else {
                    userProfile = self.school!.students![indexPath.row]
                }
                let viewController = ProfileViewController(user: userProfile)
                self.navigationController!.pushViewController(viewController, animated: true)
            }
        }
    }

    
}
