//
//  BrowseMentorsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseMentorsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mentors"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let searchBar = UISearchBar()
        searchBar.backgroundColor = UIColor.mainColor
        searchBar.tintColor = UIColor.mainColor
        searchBar.barTintColor = UIColor.mainColor
        searchBar.setHeight(44)
        self.tableView.tableHeaderView = searchBar
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = "Erica Lam Xue Millwoman"
        cell.detailTextLabel?.text = "Berkeley High School"
        cell.imageView?.image = UIImage(named: "BerkeleySunsetBlurred.jpg")
        return cell
    }
}
