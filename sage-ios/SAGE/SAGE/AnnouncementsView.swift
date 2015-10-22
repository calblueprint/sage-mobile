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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView.tableFooterView = UIView()
        self.addSubview(self.tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tableView.fillWidth()
        self.tableView.fillHeight()
    }
    
}