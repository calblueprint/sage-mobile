//
//  Session.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class Checkin: NSObject {
    var id: Int?
    var user: User?
    var startTime: NSDate?
    var endTime: NSDate?
    var school: School?
    var comment: String?
    
    init(propertyDictionary: [String: AnyObject]) {
        super.init()
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case CheckinConstants.kUser:
                let userDictionary = propertyDictionary[propertyName] as! [String: AnyObject]
                self.user = User(propertyDictionary: userDictionary)
            case CheckinConstants.kStartTime:
                let formatter = NSDateFormatter()
                formatter.dateFormat = StringConstants.JSONdateFormat
                self.startTime = formatter.dateFromString(propertyDictionary[propertyName] as! String)
            case CheckinConstants.kEndTime:
                let formatter = NSDateFormatter()
                formatter.dateFormat = StringConstants.JSONdateFormat
                self.endTime = formatter.dateFromString(propertyDictionary[propertyName] as! String)
            case CheckinConstants.kSchool:
                let schoolDictionary = propertyDictionary[propertyName] as! [String: AnyObject]
                self.school = School(propertyDictionary: schoolDictionary)
            default:
                self.setValue(value, forKey: propertyName)
            }
        }
    }
    
    init(id: Int, user: User, startTime: NSDate, endTime: NSDate, school: School, comment: String) {
        super.init()
        self.id = id
        self.user = user
        self.startTime = startTime
        self.endTime = endTime
        self.school = school
        self.comment = comment
    }
    
    override init() {
        super.init()
    }
}
