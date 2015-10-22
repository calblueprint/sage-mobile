//
//  SignUpTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/18/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController {
    
    var modalType: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
//        let leftButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonPressed")
//
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        self.navigationItem.leftBarButtonItem = leftButton
//        let navigationBar = navigationController!.navigationBar
//        navigationBar.tintColor = UIColor.blueColor()
//        
//        let leftButton =  UIBarButtonItem(title: "Left Button", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
//        let rightButton = UIBarButtonItem(title: "Right Button", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
//        
//        navigationItem.leftBarButtonItem = leftButton
//        navigationItem.rightBarButtonItem = rightButton

    }
    
    func setType(typeString: String) {
        self.modalType = typeString
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
