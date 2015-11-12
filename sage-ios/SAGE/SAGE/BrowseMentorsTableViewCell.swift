//
//  BrowseMentorsTableViewCell.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseMentorsTableViewCell: UITableViewCell {
    
    var mentorPicture = UIImageView()
    var mentorName = UILabel()
    var schoolName = UILabel()
    var totalHours = UILabel()
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(style: .Default, reuseIdentifier: "BrowseCell")
    }
    
    override func layoutSubviews() {
        
        let imageURL = NSURL(string: user.imgURL!)
        let imageData = NSData(contentsOfURL: imageURL!)
        self.mentorPicture.image = UIImage(data: imageData!)
        self.mentorName.text = user.firstName! + " " + user.lastName!
        self.schoolName.text = user.school!.name
        self.totalHours.text = String(user.totalHours)
        
        super.layoutSubviews()
        
        self.contentView.addSubview(self.mentorPicture)
        
        self.contentView.addSubview(self.mentorName)
        
        self.contentView.addSubview(self.schoolName)
        
        self.contentView.addSubview(self.totalHours)
        self.totalHours.setWidth(50)
        self.totalHours.setHeight(20)
        self.totalHours.setX(0)
        self.totalHours.setY(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
