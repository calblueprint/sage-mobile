//
//  User.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class User: NSObject {
    
    enum VolunteerLevel: Int {
        case ZeroUnit
        case OneUnit
        case TwoUnit
    }
    
    enum UserRole: Int {
        case Volunteer
        case Admin
    }
    
    var id: Int?
    var name: String?
    var school: School?
    var level: VolunteerLevel?
    var role: UserRole?
    var totalHours: Int?
    var verified: Bool?
    
    init(id: Int? = nil, name: String? = nil, school: School? = nil, level: VolunteerLevel? = nil, role: UserRole? = nil, totalHours: Int? = nil, verified: Bool? = nil) {
        super.init()
        self.id = id
        self.name = name
        self.school = school
        self.level = level
        self.role = role
        self.totalHours = totalHours
        self.verified = verified
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        super.init()
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case UserConstants.kLevel:
                switch value as! Int {
                case 0: self.level = VolunteerLevel.ZeroUnit
                case 1: self.level = VolunteerLevel.OneUnit
                case 2: self.level = VolunteerLevel.TwoUnit
                default: self.level = VolunteerLevel.ZeroUnit
                }
            case UserConstants.kRole:
                switch value as! Int {
                case 0: self.role = UserRole.Volunteer
                case 1: self.role = UserRole.Admin
                default: self.role = UserRole.Volunteer
                }
            case UserConstants.kSchool:
                let schoolDictionary = value as! [String: AnyObject]
                self.school = School(propertyDictionary: schoolDictionary)
            case UserConstants.kVerified:
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
            propertyDict[UserConstants.kId] = id
        }
        if let name = self.name {
            propertyDict[UserConstants.kName] = name
        }
        if let school = self.school {
            propertyDict[UserConstants.kSchool] = school.toDictionary()
        }
        if let level = self.level {
            propertyDict[UserConstants.kLevel] = level.rawValue
        }
        if let role = self.role {
            propertyDict[UserConstants.kRole] = role.rawValue
        }
        if let totalHours = self.totalHours {
            propertyDict[UserConstants.kTotalHours] = totalHours
        }
        if let verified = self.verified {
            var value: Int
            if (verified) {
                value = 1
            } else {
                value = 0
            }
            propertyDict[UserConstants.kVerified] = value
        }
        return propertyDict
    }
}
