//
//  User.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
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
    var firstName: String?
    var lastName: String?
    var email: String?
    var school: School?
    var level: VolunteerLevel?
    var role: UserRole?
    var totalHours: Int?
    var verified: Bool?
    
    //
    // MARK -- NSCoding
    //
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeIntegerForKey(UserConstants.kId)
        self.firstName = aDecoder.decodeObjectForKey(UserConstants.kFirstName) as? String
        self.lastName = aDecoder.decodeObjectForKey(UserConstants.kLastName) as? String
        self.email = aDecoder.decodeObjectForKey(UserConstants.kEmail) as? String
        self.school = aDecoder.decodeObjectForKey(UserConstants.kSchool) as? School
        self.level = VolunteerLevel(rawValue: aDecoder.decodeIntegerForKey(UserConstants.kLevel))
        self.role = UserRole(rawValue: aDecoder.decodeIntegerForKey(UserConstants.kRole))
        self.totalHours = aDecoder.decodeIntegerForKey(UserConstants.kTotalHours)
        self.verified = aDecoder.decodeBoolForKey(UserConstants.kVerified)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let id = self.id {
            aCoder.encodeInteger(id, forKey: UserConstants.kId)
        }
        aCoder.encodeObject(self.firstName, forKey: UserConstants.kFirstName)
        aCoder.encodeObject(self.lastName, forKey: UserConstants.kLastName)
        aCoder.encodeObject(self.email, forKey: UserConstants.kEmail)
        if let level = self.level {
            aCoder.encodeInteger(level.rawValue, forKey: UserConstants.kLevel)
        }
        if let role = self.role {
            aCoder.encodeInteger(role.rawValue, forKey: UserConstants.kRole)
        }
        aCoder.encodeObject(self.totalHours, forKey: UserConstants.kTotalHours)
        aCoder.encodeObject(self.verified, forKey: UserConstants.kVerified)
    }
    
    init(id: Int? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, school: School? = nil, level: VolunteerLevel? = nil, role: UserRole? = nil, totalHours: Int? = nil, verified: Bool? = nil) {
        super.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
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
                switch value as! String {
                case "one_unit": self.level = VolunteerLevel.OneUnit
                case "two_units": self.level = VolunteerLevel.TwoUnit
                default: self.level = VolunteerLevel.ZeroUnit
                }
            case UserConstants.kRole:
                switch value as! String {
                case "admin": self.role = UserRole.Admin
                case "volunteer": self.role = UserRole.Volunteer
                default: self.role = UserRole.Volunteer
                }
            case UserConstants.kSchool:
                let schoolDictionary = value as! [String: AnyObject]
                self.school = School(propertyDictionary: schoolDictionary)
            case UserConstants.kVerified:
                self.verified = value as? Bool
            case UserConstants.kId:
                self.id = value as? Int
            case UserConstants.kFirstName:
                self.firstName = value as? String
            case UserConstants.kLastName:
                self.lastName = value as? String
            case UserConstants.kEmail:
                self.email = value as? String
            default: break
            }
        }
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        if let id = self.id {
            propertyDict[UserConstants.kId] = id
        }
        if let firstName = self.firstName {
            propertyDict[UserConstants.kFirstName] = firstName
        }
        if let lastName = self.lastName {
            propertyDict[UserConstants.kLastName] = lastName
        }
        if let email = self.email {
            propertyDict[UserConstants.kEmail] = email
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
