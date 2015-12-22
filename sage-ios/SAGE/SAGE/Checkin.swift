//
//  Session.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class Checkin: NSObject {
    var id: Int = -1
    var user: User?
    var startTime: NSDate?
    var endTime: NSDate?
    var school: School?
    var comment: String?
    var verified: Bool = false
    
    
    init(id: Int = -1, user: User? = nil, startTime: NSDate? = nil, endTime: NSDate? = nil, school: School? = nil, comment: String? = nil, verified: Bool = false) {
        super.init()
        self.id = id
        self.user = user
        self.startTime = startTime
        self.endTime = endTime
        self.school = school
        self.comment = comment
        self.verified = verified
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
                let schoolDictionary = value as? [String: AnyObject]
                if let dict = schoolDictionary {
                    self.school = School(propertyDictionary: dict)
                }
            case CheckinConstants.kVerified:
                if !(value is NSNull) {
                    self.verified = value as! Bool
                }
            case CheckinConstants.kId:
                if !(value is NSNull) {
                    self.id = value as! Int
                }
            case CheckinConstants.kComment:
                self.comment = value as? String
            default: break
            }
        }
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        propertyDict[CheckinConstants.kId] = id
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
        propertyDict[CheckinConstants.kVerified] = self.verified
        return propertyDict
    }
    
    func stringTimeFromStartDate() -> NSString {
        let formatter = NSDateFormatter()
        formatter.dateFormat = StringConstants.displayDateFormat
        return formatter.stringFromDate(self.startTime!)
    }
    
    func stringTimeFromEndDate() -> NSString {
        let formatter = NSDateFormatter()
        formatter.dateFormat = StringConstants.displayDateFormat
        return formatter.stringFromDate(self.endTime!)
    }
}

extension Checkin: NSCopying {
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Checkin(id: self.id, user: self.user?.copy() as? User, startTime: self.startTime?.copy() as? NSDate, endTime: self.endTime?.copy() as? NSDate, school: self.school?.copy() as? School, comment: self.comment?.copy() as? String, verified: self.verified)
    }
}
