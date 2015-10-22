//
//  SignUpTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/18/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController, UINavigationBarDelegate {
    
    var modalType: String?
    var navigationBar: UINavigationBar?
    var parentVC: SignUpController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let rightButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelClicked")
        self.navigationItem.rightBarButtonItem = rightButton

    }
    
    func cancelClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.parentVC {
            let schoolHoursView = (self.parentVC!.view as! SignUpView).schoolHoursView
            if (self.modalType == "School") {
                schoolHoursView.chooseSchoolButton.setTitle("school selected", forState: UIControlState.Normal)
            } else if (self.modalType == "Hours") {
                schoolHoursView.chooseHoursButton.setTitle("hours selected", forState: UIControlState.Normal)
            }
        }
        self.cancelClicked()
    }
    
    func setType(typeString: String) {
        self.modalType = typeString
        self.navigationController!.navigationBar.topItem!.title = "Choose " + typeString
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // hardcoded for now
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = "Sample School/Hour option"
        return cell
    }

}
