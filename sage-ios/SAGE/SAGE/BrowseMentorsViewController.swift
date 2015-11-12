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
        self.tableView.tableFooterView = UIView()
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
        
        let school = School(name: "Sample School")
        let user = User(firstName: "Sameera", lastName: "Vemulapalli", school: school, totalHours: 99, imgURL: "http://ia.media-imdb.com/images/M/MV5BMjA5NTE4NTE5NV5BMl5BanBnXkFtZTcwMTcyOTY5Mw@@._V1_UY317_CR20,0,214,317_AL_.jpg")
        let cell = BrowseMentorsTableViewCell(user: user)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
}
