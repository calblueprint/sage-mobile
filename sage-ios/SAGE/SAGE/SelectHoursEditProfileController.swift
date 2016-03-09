//
//  SelectHoursEditProfileController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SelectHoursEditProfileController: SGTableViewController {
    
    weak var parentVCEditProfile: EditProfileController?
    
    init() {
        super.init(style: .Plain)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose Hours"
        self.tableView.tableFooterView = UIView()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0: cell.textLabel?.text = "0 Units"
        case 1: cell.textLabel?.text = "1 Unit"
        case 2: cell.textLabel?.text = "2 Units"
        default: cell.textLabel?.text = "0 Units"
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: self.parentVCEditProfile?.didSelectHours(.ZeroUnit)
        case 1: self.parentVCEditProfile?.didSelectHours(.OneUnit)
        case 2: self.parentVCEditProfile?.didSelectHours(.TwoUnit)
        default: self.parentVCEditProfile?.didSelectHours(.ZeroUnit)
        }
        self.navigationController?.popViewControllerAnimated(true)

    }

}
