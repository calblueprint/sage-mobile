//
//  BrowseMentorsViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseMentorsViewController: UITableViewController {
    
    var mentors: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mentors"
        // self.loadMentors()
        
    }
    
    func loadMentors() {
        AdminOperations.loadMentors { (mentorArray) -> Void in
            self.mentors = mentorArray
        }
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
        let cell = BrowseMentorsTableViewCell(withUser: User())
        return cell
    }
}
