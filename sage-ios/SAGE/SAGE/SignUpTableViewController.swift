//
//  SignUpTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/18/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController, UINavigationBarDelegate {
    enum ContentType: Int {
        case School
        case Hours
    }
    
    enum VolunteerLevelStrings: String {
        case ZeroUnits = "1 hour/week"
        case OneUnit = "2 hours/week"
        case TwoUnits = "3 hours/week"
    }
    
    var modalType: ContentType = .School
    var navigationBar: UINavigationBar?
    weak var parentVC: SignUpController?
    var schools: [School] = []
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var currentErrorMessage: ErrorView?
    var volunteerLevelDict = NSMutableDictionary()
    
    init(type: ContentType) {
        super.init(style: .Plain)
        self.modalType = type
        volunteerLevelDict[VolunteerLevelStrings.ZeroUnits.rawValue] = User.VolunteerLevel.ZeroUnit.rawValue
        volunteerLevelDict[VolunteerLevelStrings.OneUnit.rawValue] = User.VolunteerLevel.OneUnit.rawValue
        volunteerLevelDict[VolunteerLevelStrings.TwoUnits.rawValue] = User.VolunteerLevel.TwoUnit.rawValue
        if self.modalType == ContentType.School {
            self.loadSchoolData()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView()
        
        if self.modalType == .School {
            self.view.addSubview(self.activityIndicator)
            self.view.bringSubviewToFront(self.activityIndicator)
            self.activityIndicator.centerHorizontally()
            self.activityIndicator.centerVertically()
            self.activityIndicator.startAnimating()
        }
        
        let rightButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelClicked")
        self.navigationItem.rightBarButtonItem = rightButton
        
        if self.modalType == ContentType.School {
            self.navigationController?.navigationBar.topItem!.title = "Choose School"
        } else  if self.modalType == ContentType.Hours {
            self.navigationController?.navigationBar.topItem!.title = "Choose Hours"
        }

    }
    
    func cancelClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadSchoolData() {
        AdminOperations.loadSchools({ (schoolArray) -> Void in
            for school in schoolArray {
                self.schools.append(school)
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage, size: 64.0)
        }
    }
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, currentError: error)
        self.currentErrorMessage = errorView
    }

    //
    // MARK: - Table view data source
    //
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // hardcoded for now
        if self.modalType == ContentType.School {
            return self.schools.count
        } else {
            return 3
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.modalType == ContentType.School {
            let school = self.schools[indexPath.row]
            var cell = self.tableView.dequeueReusableCellWithIdentifier("BrowseSchoolsCell")
            if cell == nil {
                cell = SchoolsTableViewCell(style: .Subtitle, reuseIdentifier: "BrowseSchoolsCell")
            }
            (cell as! SchoolsTableViewCell).configureWithSchool(school)
            return cell!

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            switch indexPath.row {
            case 0: cell.textLabel?.text = VolunteerLevelStrings.ZeroUnits.rawValue
            case 1: cell.textLabel?.text = VolunteerLevelStrings.OneUnit.rawValue
            case 2: cell.textLabel?.text = VolunteerLevelStrings.TwoUnits.rawValue
            default: cell.textLabel?.text = VolunteerLevelStrings.ZeroUnits.rawValue
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.parentVC {
            let schoolHoursView = (self.parentVC!.view as! SignUpView).schoolHoursView
            if (self.modalType == ContentType.School) {
                let school = self.schools[indexPath.row]
                schoolHoursView.chooseSchoolButton.setTitle(school.name!, forState: .Normal)
                self.parentVC?.school = school
            } else if (self.modalType == ContentType.Hours) {
                switch indexPath.row{
                case 0: schoolHoursView.chooseHoursButton.setTitle(VolunteerLevelStrings.ZeroUnits.rawValue, forState: .Normal)
                case 1: schoolHoursView.chooseHoursButton.setTitle(VolunteerLevelStrings.OneUnit.rawValue, forState: .Normal)
                case 2: schoolHoursView.chooseHoursButton.setTitle(VolunteerLevelStrings.TwoUnits.rawValue, forState: .Normal)
                default: schoolHoursView.chooseHoursButton.setTitle(VolunteerLevelStrings.ZeroUnits.rawValue, forState: .Normal)
                }
                let levelString = schoolHoursView.chooseHoursButton.titleLabel!.text!
                self.parentVC?.level = self.volunteerLevelDict[levelString] as? Int
            }
        }
        self.cancelClicked()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.modalType == ContentType.School {
            return SchoolsTableViewCell.cellHeight()
        } else {
            return UITableViewAutomaticDimension
        }
    }

}
