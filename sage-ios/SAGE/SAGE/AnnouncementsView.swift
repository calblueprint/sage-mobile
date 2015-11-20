//
//  AnnouncementsView.swift
//  SAGE
//
//  Created by Erica Yin on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class AnnouncementsView: UIView {
  
    var tableView = UITableView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView.tableFooterView = UIView()
        self.addSubview(self.tableView)
        self.addSubview(self.activityView)
        self.activityView.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.fillWidth()
        self.tableView.fillHeight()
        self.activityView.centerInSuperview()
    }
    
}
