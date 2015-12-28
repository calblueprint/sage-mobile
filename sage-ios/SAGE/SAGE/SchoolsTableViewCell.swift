//
//  SchoolsTableViewCell
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SchoolsTableViewCell: UITableViewCell {
    
    var schoolName = UILabel()
    var directorName = UILabel()
    var numStudents = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle  = .None
        self.setUpSubviews()
    }
    
    func setUpSubviews() {
        self.contentView.addSubview(self.numStudents)
        self.numStudents.textColor = UIColor.secondaryTextColor
        self.numStudents.font = UIFont.getDefaultFont(16)
        
        self.contentView.addSubview(self.schoolName)
        self.schoolName.font = UIFont.getSemiboldFont(16)
        
        self.contentView.addSubview(self.directorName)
        self.directorName.font = UIFont.getDefaultFont(14)
        self.directorName.textColor = UIColor.secondaryTextColor
    }
    
    func configureWithSchool(school: School) {
        self.schoolName.text = school.name
        self.directorName.text = school.director?.fullName()
        if let studentsNum = school.students?.count {
            var labelText = String(studentsNum)
            if studentsNum == 1 {
                labelText += " student"
            } else {
                labelText += " students"
            }
            self.numStudents.text = labelText
        }

        self.layoutSubviews()
    }
    
    override func prepareForReuse() {
        self.schoolName.text = ""
        self.directorName.text = ""
        self.numStudents.text = ""
    }
    
    static func cellHeight() -> CGFloat {
        return 52.0
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.numStudents.sizeToFit()
        self.numStudents.centerVertically()
        self.numStudents.setX(self.frame.width - self.numStudents.frame.width - UIConstants.sideMargin)
        
        self.schoolName.sizeToFit()
        self.schoolName.setY(UIConstants.verticalMargin)
        self.schoolName.setX(UIConstants.sideMargin)
        self.schoolName.setWidth(CGRectGetMinX(self.numStudents.frame) - UIConstants.sideMargin)
        
        self.directorName.sizeToFit()
        self.directorName.setY(CGRectGetMaxY(self.schoolName.frame))
        self.directorName.setX(UIConstants.sideMargin)
        self.directorName.setWidth(CGRectGetMinX(self.numStudents.frame) - UIConstants.sideMargin)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
