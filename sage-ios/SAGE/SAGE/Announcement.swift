//
//  Announcement.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class Announcement: NSObject {
    
    enum Category: Int {
        case General = 0
        case School = 1
    }
    
    var id: Int?
    var sender: User?
    var title: String?
    var text: String?
    var timeCreated: NSDate?
    var school: School?
    
    init(id: Int? = nil, sender: User? = nil, title: String? = nil, text: String? = nil, timeCreated: NSDate? = nil, school: School? = nil) {
        super.init()
        self.id = id
        self.sender = sender;
        self.title = title;
        self.text = text;
        self.timeCreated = timeCreated;
        self.school = school;
    }
    
    init(properties propertyDictionary: [String: AnyObject]) {
        super.init()
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case AnnouncementConstants.kSender:
                let userDictionary = value as! [String: AnyObject]
                self.sender = User(propertyDictionary: userDictionary)
            case AnnouncementConstants.kTimeCreated:
                let formatter = NSDateFormatter()
                formatter.dateFormat = StringConstants.JSONdateFormat
                self.timeCreated = formatter.dateFromString(value as! String)
            case AnnouncementConstants.kSchool:
                if !(value is NSNull) {
                    let schoolDictionary = value as! [String: AnyObject]
                    self.school = School(propertyDictionary: schoolDictionary)
                }
            case AnnouncementConstants.kId:
                self.id = value as? Int
            case AnnouncementConstants.kTitle:
                self.title = value as? String
            case AnnouncementConstants.kText:
                self.text = value as? String
            default: break
            }
        }
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        if let id = self.id {
            propertyDict[AnnouncementConstants.kId] = id
        }
        if let sender = self.sender {
            propertyDict[AnnouncementConstants.kSender] = sender.toDictionary()
        }
        if let title = self.title {
            propertyDict[AnnouncementConstants.kTitle] = title
        }
        if let text = self.text {
            propertyDict[AnnouncementConstants.kText] = text
        }
        if let timeCreated = self.timeCreated {
            let formatter = NSDateFormatter()
            formatter.dateFormat = StringConstants.JSONdateFormat
            propertyDict[AnnouncementConstants.kTimeCreated] = formatter.stringFromDate(timeCreated)
        }
        if let school = self.school {
            propertyDict[AnnouncementConstants.kSchool] = school.toDictionary()
        }
        return propertyDict
    }
    
    func isBefore(otherAnnouncement: Announcement) -> Bool {
        if (self.timeCreated!.compare(otherAnnouncement.timeCreated!) == NSComparisonResult.OrderedAscending) {
            return false
        } else {
            return true
        }
    }
}

extension Announcement: NSCopying {
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Announcement(id: self.id, sender: self.sender?.copy() as? User, title: self.title?.copy() as? String, text: self.text?.copy() as? String, timeCreated: self.timeCreated?.copy() as? NSDate, school: self.school?.copy() as? School)
    }
}