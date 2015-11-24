//
//  AddSchoolDirectorTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddSchoolDirectorTableViewController: UITableViewController {
    
    var directors: [[User]]?
    var currentErrorMessage: ErrorView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
    weak var parentVC: AddSchoolController?
    
    init() {
        super.init(style: .Plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionIndexColor = UIColor.mainColor
        self.title = "Choose Director"
        self.tableView.tableFooterView = UIView()
        self.tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.mainColor
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "loadDirectors", forControlEvents: .ValueChanged)
        
        self.loadDirectors()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }
    
    func loadDirectors() {
        AdminOperations.loadDirectors({ (directorArray) -> Void in
            let alphabet = "abcdefghijklmnopqrstuvwxyz"
            var charArray = [String: Int]()
            self.directors = [[User]]()
            for i in 0...25 {
                self.directors!.append([User]())
                let letterChar = alphabet[alphabet.startIndex.advancedBy(i)]
                let letterString = String(letterChar)
                charArray[letterString] = i
            }
            
            for director in directorArray {
                let firstName = director.firstName!
                let firstLetter = String(firstName[firstName.startIndex.advancedBy(0)]).lowercaseString
                let firstLetterIndex = charArray[firstLetter]
                self.directors![firstLetterIndex!].append(director)
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()
            
            }) { (errorMessage) -> Void in
                self.showErrorAndSetMessage(errorMessage)
        }
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var charArray = [String]()
        for i in 0...25 {
            let letterChar = alphabet[alphabet.startIndex.advancedBy(i)]
            let letterString = String(letterChar)
            charArray.append(letterString)
        }
        return charArray
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letterChar = alphabet[alphabet.startIndex.advancedBy(section)]
        return String(letterChar)
    }
    
    func showErrorAndSetMessage(message: String) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, currentError: error, color: UIColor.mainColor)
        self.currentErrorMessage = errorView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = self.directors {
            if self.directors![section].count == 0 {
                return 0.0
            } else {
                return 22.0
            }
        } else {
            return 0.0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let directors = self.directors {
            return directors[section].count
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 26
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var charArray = [String: Int]()
        for i in 0...25 {
            let letterChar = alphabet[alphabet.startIndex.advancedBy(i)]
            let letterString = String(letterChar)
            charArray[letterString] = i
        }
        return charArray[title.lowercaseString]!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = self.directors![indexPath.section][indexPath.row]
        let cell = BrowseMentorsTableViewCell()
        cell.configureWithUser(user)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return BrowseMentorsTableViewCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.parentVC!.didSelectDirector(self.directors![indexPath.section][indexPath.row])
        self.navigationController!.popViewControllerAnimated(true)
    }

}
