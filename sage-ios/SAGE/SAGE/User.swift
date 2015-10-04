//
//  User.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class User: NSObject {
    
    enum UserLevel: Int {
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
    var level: UserLevel?
    var role: UserRole?
    var totalHours: Int?
    var verified: Bool?
    
    init(propertyDictionary: [String: AnyObject]) {
        super.init()
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case UserConstants.kLevel:
                switch propertyDictionary[propertyName] as! Int {
                case 0: self.level = UserLevel.ZeroUnit
                case 1: self.level = UserLevel.OneUnit
                case 2: self.level = UserLevel.TwoUnit
                default: self.level = UserLevel.ZeroUnit
                }
            case UserConstants.kRole:
                switch propertyDictionary[propertyName] as! Int {
                case 0: self.role = UserRole.Volunteer
                case 1: self.role = UserRole.Admin
                default: self.role = UserRole.Volunteer
                }
            case UserConstants.kSchool:
                let schoolDictionary = propertyDictionary[propertyName] as! [String: AnyObject]
                self.school = School(propertyDictionary: schoolDictionary)
            default:
                self.setValue(value, forKey: propertyName)
            }
        }
    }
    
    init(id: Int, name: String, school: School, level: UserLevel, role: UserRole, totalHours: Int, verified: Bool) {
        super.init()
        self.id = id
        self.name = name
        self.school = school
        self.level = level
        self.role = role
        self.totalHours = totalHours
        self.verified = verified
    }
    
    override init() {
        super.init()
    }
    
    
}
