//
//  ExpandedTableViewController.swift
//  SAGE
//
//  Created by Andrew Millman on 2/22/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class ExpandedTableViewController<Element> : UITableViewController {
    
    private(set) var list = [Element]()
    private(set) var displayText: (Element) -> String = {_ in return ""}
    private(set) var listRetriever: ((ExpandedTableViewController<Element>) -> Void)?
    private(set) var handler: (Element) -> Void = {_ in }
    
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    //
    // MARK: - Initialization
    //
    required init(list: [Element], displayText: (Element) -> String, handler: (Element) -> Void) {
        super.init(style: .Plain)
        self.list = list
        self.displayText = displayText
        self.handler = handler
    }
    
    convenience init(listRetriever:(ExpandedTableViewController<Element>) -> Void, displayText: (Element) -> String, handler: (Element) -> Void) {
        self.init(list: [Element](), displayText: displayText, handler: handler)
        self.listRetriever = listRetriever
    }
    
    //
    // MARK: - View Controller Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        self.listRetriever?(self)
        
        self.tableView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }
    
    //
    // MARK: - Public Methods
    //
    func setList(list:[Element]) {
        self.list = list
        self.activityIndicator.stopAnimating()
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    
    //
    // MARK: - UITableViewDelegate
    //
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ExpandMenu")
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"ExpandMenu")
            cell?.textLabel?.font = UIFont.getDefaultFont(14)
        }
        cell?.textLabel?.text = self.displayText(self.list[indexPath.row])
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.handler(self.list[indexPath.row])
    }
}