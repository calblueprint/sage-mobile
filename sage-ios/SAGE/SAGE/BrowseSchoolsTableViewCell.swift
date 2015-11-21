//
//  BrowseSchoolsTableViewCell.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseSchoolsTableViewCell: UITableViewCell {
    
    init() {
        super.init(style: .Subtitle, reuseIdentifier: "BrowseSchoolsCell")
        self.selectionStyle = .None
    }
    
    func configureWithSchool(school: School) {
        self.detailTextLabel?.text = "director name" // hardcoded for now because not fetched by network request
        self.textLabel?.text = school.name!
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
