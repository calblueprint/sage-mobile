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
    
    var modalType: ContentType
    var navigationBar: UINavigationBar?
    weak var parentVC: SignUpController?
    var schools: [String] = []
    var schoolDict: NSMutableDictionary
    var volunteerLevelDict: NSMutableDictionary
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    init(type: ContentType, schoolIDDict: NSMutableDictionary, volunteerlevelDict: NSMutableDictionary) {
        self.modalType = type
        volunteerlevelDict[VolunteerLevelStrings.ZeroUnits.rawValue] = User.VolunteerLevel.ZeroUnit.rawValue
        volunteerlevelDict[VolunteerLevelStrings.OneUnit.rawValue] = User.VolunteerLevel.OneUnit.rawValue
        volunteerlevelDict[VolunteerLevelStrings.TwoUnits.rawValue] = User.VolunteerLevel.TwoUnit.rawValue
        self.volunteerLevelDict = volunteerlevelDict
        self.schoolDict = schoolIDDict
        super.init(style: .Plain)
        if self.modalType == ContentType.School {
            self.loadSchoolData()
        }
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
            self.navigationController!.navigationBar.topItem!.title = "Choose School"
        } else  if self.modalType == ContentType.Hours {
            self.navigationController!.navigationBar.topItem!.title = "Choose Hours"
        }

    }
    
    func cancelClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadSchoolData() {
        AnnouncementsOperations.loadSchools { (schoolDict) -> Void in
            for schoolDict in schoolDict {
                self.schools.append((schoolDict as! NSDictionary)["name"] as! String)
                self.schoolDict[(schoolDict as! NSDictionary)["name"] as! String] = ((schoolDict as! NSDictionary)["id"] as! Int)
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if self.modalType == ContentType.School {
            cell.textLabel?.text = self.schools[indexPath.row]
        } else if self.modalType == ContentType.Hours {
            switch indexPath.row {
            case 0: cell.textLabel?.text = VolunteerLevelStrings.ZeroUnits.rawValue
            case 1: cell.textLabel?.text = VolunteerLevelStrings.OneUnit.rawValue
            case 2: cell.textLabel?.text = VolunteerLevelStrings.TwoUnits.rawValue
            default: cell.textLabel?.text = VolunteerLevelStrings.ZeroUnits.rawValue
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.parentVC {
            let schoolHoursView = (self.parentVC!.view as! SignUpView).schoolHoursView
            if (self.modalType == ContentType.School) {
                let title = self.schools[indexPath.row]
                schoolHoursView.chooseSchoolButton.setTitle(title, forState: .Normal)
            } else if (self.modalType == ContentType.Hours) {
                switch indexPath.row{
                case 0: schoolHoursView.chooseHoursButton.setTitle(VolunteerLevelStrings.ZeroUnits.rawValue, forState: .Normal)
                case 1: schoolHoursView.chooseHoursButton.setTitle(VolunteerLevelStrings.OneUnit.rawValue, forState: .Normal)
                case 2: schoolHoursView.chooseHoursButton.setTitle(VolunteerLevelStrings.TwoUnits.rawValue, forState: .Normal)
                default: schoolHoursView.chooseHoursButton.setTitle(VolunteerLevelStrings.ZeroUnits.rawValue, forState: .Normal)
                }
            }
        }
        self.cancelClicked()
    }

}
