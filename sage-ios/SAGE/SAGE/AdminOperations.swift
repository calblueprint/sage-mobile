//
//  AdminOperations.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/11/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftKeychainWrapper

class AdminOperations {
    
    static func loadMentors(completion: (([User]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetMentors, parameters: nil, success: { (operation, data) -> Void in
            var userArray = [User]()
            let userData = data["users"] as! [AnyObject]
            for userDict in userData {
                let user = User(propertyDictionary: userDict as! [String: AnyObject])
                userArray.append(user)
            }
            completion(userArray)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func loadAdmins(completion: (([User]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetAdmins, parameters: nil, success: { (operation, data) -> Void in
            var userArray = [User]()
            let userData = data["users"] as! [AnyObject]
            for userDict in userData {
                let user = User(propertyDictionary: userDict as! [String: AnyObject])
                userArray.append(user)
            }
            completion(userArray)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func createAnnouncement(announcement: Announcement, completion: (Announcement) -> Void, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let announcementDict = announcement.toDictionary()
        // TODO: Create Announcement
    }
            
    static func loadCheckinRequests(completion: (([Checkin]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetCheckins, parameters: nil, success: { (operation, data) -> Void in
            var checkins = [Checkin]()
            let checkinArray = data["check_ins"] as! [AnyObject]
            for checkinDict in checkinArray {
                let checkin = Checkin(propertyDictionary: checkinDict as! [String : AnyObject])
                checkins.append(checkin)
            }
            completion(checkins)

            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
    }

    
    static func loadSchools(completion: (([School]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetSchools, parameters: nil, success: { (operation, data) -> Void in
            var schools = [School]()
            let schoolArray = data["schools"] as! [AnyObject]
            for schoolDict in schoolArray {
                let school = School(propertyDictionary: schoolDict as! [String: AnyObject])
                schools.append(school)
            }
            completion(schools)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func loadSchool(id: Int, completion: ((School) -> Void), failure: (String) -> Void) {
        let requestURL = StringConstants.kSchoolDetailURL(id)
        let manager = BaseOperation.manager()
        manager.GET(requestURL, parameters: nil, success: { (operation, data) -> Void in
            var schoolDict = data["school"] as! [String: AnyObject]
            let userDict = schoolDict["users"] as! [AnyObject]
            schoolDict.removeValueForKey("users")
            let school = School(propertyDictionary: schoolDict)
            var students = [User]()
            for user in userDict {
                let user = User(propertyDictionary: user as! [String: AnyObject])
                students.append(user)
            }
            school.students = students
            completion(school)
            
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
    }
    
    
    static func loadSignUpRequests(completion: (([User]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetSignUpRequests, parameters: nil, success: { (operation, data) -> Void in
            var users = [User]()
            let userArray = data["users"] as! [AnyObject]
            for userDict in userArray {
                let user = User(propertyDictionary: userDict as! [String : AnyObject])
                users.append(user)
            }
            completion(users)
        }) { (operation, error) -> Void in
            failure(error.localizedDescription)
        }
    }
    
    static func createSchool(school: School, completion: ((School) -> Void)?, failure: (String) -> Void){
        let manager = BaseOperation.manager()
        // TODO: make a network request
    }
    
    static func editSchool(school: School, completion: ((School) -> Void)?, failure: (String) -> Void){
        let manager = BaseOperation.manager()
        // TODO: make a network request
    }
    
    static func approveCheckin(checkin: Checkin, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        // TODO: make a network request
    }
    
    static func removeCheckin(checkin: Checkin, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        // TODO: make a network request
    }
    
    static func verifyUser(user: User, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        // TODO: make a network request
    }
    
    static func removeUser(user: User, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        // TODO: make a network request
    }
    
}
