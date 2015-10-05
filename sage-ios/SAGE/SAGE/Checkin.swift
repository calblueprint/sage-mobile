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
    var verified: Bool?
    
    
    init(id: Int? = nil, user: User? = nil, startTime: NSDate? = nil, endTime: NSDate? = nil, school: School? = nil, comment: String? = nil, verified: Bool? = nil) {
        super.init()
        self.id = id
        self.user = user
        self.startTime = startTime
        self.endTime = endTime
        self.school = school
        self.comment = comment
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        super.init()
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case CheckinConstants.kUser:
                let userDictionary = value as! [String: AnyObject]
                self.user = User(propertyDictionary: userDictionary)
            case CheckinConstants.kStartTime:
                let formatter = NSDateFormatter()
                formatter.dateFormat = StringConstants.JSONdateFormat
                self.startTime = formatter.dateFromString(value as! String)
            case CheckinConstants.kEndTime:
                let formatter = NSDateFormatter()
                formatter.dateFormat = StringConstants.JSONdateFormat
                self.endTime = formatter.dateFromString(value as! String)
            case CheckinConstants.kSchool:
                let schoolDictionary = value as! [String: AnyObject]
                self.school = School(propertyDictionary: schoolDictionary)
            case CheckinConstants.kVerified:
                if value as! Int == 0 {
                    self.verified = false;
                } else {
                    self.verified = true;
                }
            default:
                self.setValue(value, forKey: propertyName)
            }
        }
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        if let id = self.id {
            propertyDict[CheckinConstants.kId] = id
        }
        if let user = self.user {
            propertyDict[CheckinConstants.kUser] = user.toDictionary()
        }
        if let startTime = self.startTime {
            let formatter = NSDateFormatter()
            formatter.dateFormat = StringConstants.JSONdateFormat
            propertyDict[CheckinConstants.kStartTime] = formatter.stringFromDate(startTime)
        }
        if let endTime = self.endTime {
            let formatter = NSDateFormatter()
            formatter.dateFormat = StringConstants.JSONdateFormat
            propertyDict[CheckinConstants.kEndTime] = formatter.stringFromDate(endTime)
        }
        if let school = self.school {
            propertyDict[CheckinConstants.kSchool] = school.toDictionary()
        }
        if let comment = self.comment {
            propertyDict[CheckinConstants.kComment] = comment
        }
        if let verified = self.verified {
            var value: Int
            if (verified) {
                value = 1
            } else {
                value = 0
            }
            propertyDict[CheckinConstants.kVerified] = value
        }
        return propertyDict
    }
}
