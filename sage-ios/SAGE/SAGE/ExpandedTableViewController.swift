//
//  ExpandedTableViewController.swift
//  SAGE
//
//  Created by Andrew Millman on 2/22/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class ExpandedTableViewController<Element> : UITableViewController {

    var list = [Element]()
    var displayText: (Element) -> String = {_ in return ""}
    var handler: (Element) -> Void = {_ in }

    //
    // MARK: - Initialization
    //
    required init(list: [Element], displayText: (Element) -> String, handler: (Element) -> Void) {
        super.init(style: .Plain)
        self.list = list
        self.displayText = displayText
        self.handler = handler
    }

    //
    // MARK: - View Controller Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
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