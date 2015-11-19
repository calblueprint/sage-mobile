//
//  BrowseMentorsTableViewCell.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseSchoolsTableViewCell: UITableViewCell {
    
    init() {
        super.init(style: .Default, reuseIdentifier: "BrowseSchoolsCell")
        self.selectionStyle = .None
    }
    
    func configureWithSchool(school: School) {

    }
    
    static func cellHeight() -> CGFloat {
        return 52.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
