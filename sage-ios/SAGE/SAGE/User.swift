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
        case Default = -1
        case ZeroUnit = 0
        case OneUnit = 1
        case TwoUnit = 2
    }
    
    enum UserRole: Int {
        case Default = -1
        case Volunteer = 0
        case Admin = 1
        case President = 2
    }
        
    var id: Int = -1
    var firstName: String?
    var lastName: String?
    var email: String?
    var school: School?
    var level: VolunteerLevel = .Default
    var role: UserRole = .Default
    var verified: Bool = false
    var imageURL: NSURL?
    var directorID: Int = -1
    var semesterSummary: SemesterSummary = SemesterSummary()
    
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
        self.verified = aDecoder.decodeBoolForKey(UserConstants.kVerified)
        self.directorID = aDecoder.decodeIntegerForKey(UserConstants.kDirectorID)
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
        aCoder.encodeBool(self.verified, forKey: UserConstants.kVerified)
        aCoder.encodeInteger(self.directorID, forKey: UserConstants.kDirectorID)
    }
    
    init(id: Int = -1, firstName: String? = nil, lastName: String? = nil, email: String? = nil, school: School? = nil, level: VolunteerLevel = .Default, role: UserRole = .Default, verified: Bool = false, imgURL: NSURL? = nil, directorID: Int = -1, semesterSummary: SemesterSummary = SemesterSummary()) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.school = school
        self.level = level
        self.role = role
        self.verified = verified
        self.imageURL = imgURL
        self.directorID = directorID
        self.semesterSummary = semesterSummary
        super.init()
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        // set default values
        self.id = -1
        self.verified = false
        self.level = .Default
        self.role = .Default
        
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case UserConstants.kLevel:
                if let val = value as? Int {
                    switch val {
                    case 0: self.level = VolunteerLevel.ZeroUnit
                    case 1: self.level = VolunteerLevel.OneUnit
                    case 2: self.level = VolunteerLevel.TwoUnit
                    default: break
                    }
                }
            case UserConstants.kRole:
                if let val = value as? Int {
                    switch val {
                    case 0: self.role = UserRole.Volunteer
                    case 1: self.role = UserRole.Admin
                    case 2: self.role = UserRole.President
                    default: break
                    }
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
            case UserConstants.kDirectorID:
                if let intValue = value as? Int {
                    self.directorID = intValue
                }
            case UserConstants.kSemesterSummary:
                let semesterSummaryDictionary = value as! [String: AnyObject]
                self.semesterSummary = SemesterSummary(propertyDictionary: semesterSummaryDictionary)
            default: break
            }
        }
        super.init()
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        if -1 != self.id {
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
            case .President: propertyDict[UserConstants.kRole] = "president"
            default: break
            }
        }
        if -1 != self.directorID {
            propertyDict[UserConstants.kDirectorID] = self.directorID
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
    
    func isBefore(otherUser: User) -> Bool {
        return self.firstName < otherUser.firstName
    }
    
    func isDirector() -> Bool {
        return (self.role == .Admin || self.role == .President) && self.directorID != -1
    }
}

extension User: NSCopying {
    func copyWithZone(zone: NSZone) -> AnyObject {
        return User(id: self.id, firstName: self.firstName?.copy() as? String, lastName: self.lastName?.copy() as? String, email: self.email?.copy() as? String, school: self.school?.copy() as? School, level: self.level, role: self.role, verified: self.verified, imgURL: self.imageURL?.copy() as? NSURL, directorID: self.directorID, semesterSummary: self.semesterSummary)
    }
}
