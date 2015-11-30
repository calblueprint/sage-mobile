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
        case Default
    }
    
    enum UserRole: Int {
        case Volunteer
        case Admin
        case Director
        case Default
    }
    
    enum DefaultValues: Int {
        case DefaultID = -1
        case DefaultHours = -2
    }
        
    var id: Int = DefaultValues.DefaultID.rawValue
    var firstName: String?
    var lastName: String?
    var email: String?
    var school: School?
    var level: VolunteerLevel = .Default
    var role: UserRole = .Default
    var totalHours: Int = DefaultValues.DefaultHours.rawValue
    var verified: Bool = false
    var imageURL: NSURL?
    
    
    //
    // MARK -- NSCoding
    //
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey(UserConstants.kId)
        self.firstName = aDecoder.decodeObjectForKey(UserConstants.kFirstName) as? String
        self.lastName = aDecoder.decodeObjectForKey(UserConstants.kLastName) as? String
        self.email = aDecoder.decodeObjectForKey(UserConstants.kEmail) as? String
        self.school = aDecoder.decodeObjectForKey(UserConstants.kSchool) as? School
        self.level = VolunteerLevel(rawValue: aDecoder.decodeIntegerForKey(UserConstants.kLevel))!
        self.role = UserRole(rawValue: aDecoder.decodeIntegerForKey(UserConstants.kRole))!
        self.totalHours = aDecoder.decodeIntegerForKey(UserConstants.kTotalHours)
        self.verified = aDecoder.decodeBoolForKey(UserConstants.kVerified)
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(id, forKey: UserConstants.kId)
        aCoder.encodeObject(self.firstName, forKey: UserConstants.kFirstName)
        aCoder.encodeObject(self.lastName, forKey: UserConstants.kLastName)
        aCoder.encodeObject(self.email, forKey: UserConstants.kEmail)
        aCoder.encodeObject(self.school, forKey: UserConstants.kSchool)
        aCoder.encodeInteger(level.rawValue, forKey: UserConstants.kLevel)
        aCoder.encodeInteger(role.rawValue, forKey: UserConstants.kRole)
        aCoder.encodeInteger(self.totalHours, forKey: UserConstants.kTotalHours)
        aCoder.encodeBool(self.verified, forKey: UserConstants.kVerified)
    }
    
    init(id: Int = DefaultValues.DefaultID.rawValue, firstName: String? = nil, lastName: String? = nil, email: String? = nil, school: School? = nil, level: VolunteerLevel = .Default, role: UserRole = .Default, totalHours: Int = DefaultValues.DefaultHours.rawValue, verified: Bool = false, imgURL: NSURL? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.school = school
        self.level = level
        self.role = role
        self.totalHours = totalHours
        self.verified = verified
        self.imageURL = imgURL
        super.init()
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        // set default values
        self.id = DefaultValues.DefaultID.rawValue
        self.totalHours = DefaultValues.DefaultHours.rawValue
        self.verified = false
        self.level = .Default
        self.role = .Default
        
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case UserConstants.kLevel:
                switch value as! String {
                case "one_unit": self.level = VolunteerLevel.OneUnit
                case "two_units": self.level = VolunteerLevel.TwoUnit
                default: self.level = VolunteerLevel.Default
                }
            case UserConstants.kRole:
                switch value as! String {
                case "admin": self.role = UserRole.Admin
                case "volunteer": self.role = UserRole.Volunteer
                case "director": self.role = UserRole.Director
                default: self.role = UserRole.Default
                }
            case UserConstants.kSchool:
                let schoolDictionary = value as! [String: AnyObject]
                self.school = School(propertyDictionary: schoolDictionary)
            case UserConstants.kVerified:
                if let val = value as? Bool {
                    self.verified = val
                }
            case UserConstants.kId:
                if let val = value as? Int {
                    self.id = val
                }
            case UserConstants.kFirstName:
                self.firstName = value as? String
            case UserConstants.kLastName:
                self.lastName = value as? String
            case UserConstants.kEmail:
                self.email = value as? String
            case UserConstants.kImgURL:
                if let urlString = value as? String {
                    let url = NSURL(string: urlString)
                    self.imageURL = url
                }
            default: break
            }
        }
        super.init()
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        if DefaultValues.DefaultID.rawValue != self.id {
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
        if VolunteerLevel.Default != self.level {
            switch self.level {
            case .OneUnit: propertyDict[UserConstants.kLevel] = "one_unit"
            case .TwoUnit: propertyDict[UserConstants.kLevel] = "two_units"
            default: propertyDict[UserConstants.kLevel] = "zero_units"
            }
        }
        if UserRole.Default != self.role {
            switch self.role {
            case .Admin: propertyDict[UserConstants.kRole] = "admin"
            case .Volunteer: propertyDict[UserConstants.kRole] = "volunteer"
            case .Director: propertyDict[UserConstants.kRole] = "director"
            default: break
            }
        }
        if DefaultValues.DefaultHours.rawValue != self.totalHours {
            propertyDict[UserConstants.kTotalHours] = totalHours
        }
        propertyDict[UserConstants.kVerified] = verified
        return propertyDict
    }
    
    func volunteerLevelToString(level: VolunteerLevel) -> String {
        switch level {
            case .OneUnit:
                return "1 Unit"
            case .TwoUnit:
                return "2 Units"
            default:
                return "Volunteer"
        }
    }

    func fullName() -> String {
        return self.firstName! + " " + self.lastName!
    }
    
    func getRequiredHours() -> Int {
        switch self.level {
        case .ZeroUnit: return 1
        case .OneUnit: return 2
        case .TwoUnit: return 3
        default: return 0
        }
    }
}
