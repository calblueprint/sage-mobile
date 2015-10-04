//
//  Announcement.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class Announcement: NSObject {
    
    var id: Int?
    var sender: User?
    var title: String?
    var text: String?
    var timeCreated: NSDate?
    var school: School?
    
    init(id: Int, sender: User, title: String, text: String, timeCreated: NSDate, school: School) {
        super.init()
        self.id = id
        self.sender = sender;
        self.title = title;
        self.text = text;
        self.timeCreated = timeCreated;
        self.school = school;
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        super.init()
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case AnnouncementConstants.kSender:
                let userDictionary = propertyDictionary[propertyName] as! [String: AnyObject]
                self.sender = User(propertyDictionary: userDictionary)
            case AnnouncementConstants.kTimeCreated:
                let formatter = NSDateFormatter()
                formatter.dateFormat = StringConstants.JSONdateFormat
                self.timeCreated = formatter.dateFromString(propertyDictionary[propertyName] as! String)
            case AnnouncementConstants.kSchool:
                let schoolDictionary = propertyDictionary[propertyName] as! [String: AnyObject]
                self.school = School(propertyDictionary: schoolDictionary)
            default:
                self.setValue(value, forKey: propertyName)
            }
        }
    }
    
    override init() {
        super.init()
    }
}