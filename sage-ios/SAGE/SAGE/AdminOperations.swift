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
            let userData = ((data as! NSMutableDictionary)["users"] as! NSMutableArray)
            for userDict in userData {
                let dict = userDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let user = User(propertyDictionary: swiftDict)
                userArray.append(user)
            }
            completion(userArray)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func loadDirectors(completion: (([User]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetUsers, parameters: nil, success: { (operation, data) -> Void in
            var userArray = [User]()
            let userData = ((data as! NSMutableDictionary)["users"] as! NSMutableArray)
            for userDict in userData {
                let dict = userDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let user = User(propertyDictionary: swiftDict)
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
            // handle the data and run success on an nsmutablearray
            var checkins = [Checkin]()
            let checkinArray = (data as! NSMutableDictionary)["check_ins"] as! NSMutableArray
            for checkinDict in checkinArray {
                let dict = checkinDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let checkin = Checkin(propertyDictionary: swiftDict)
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
            let schoolArray = data["schools"] as! NSMutableArray
            for schoolDict in schoolArray {
                let dict = schoolDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let school = School(propertyDictionary: swiftDict)
                schools.append(school)
            }
            completion(schools)
            // handle the data and run success on an nsmutablearray
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func loadSchool(id: Int, completion: ((School) -> Void), failure: (String) -> Void) {
        let requestURL = StringConstants.kSchoolDetailURL(id)
        let manager = BaseOperation.manager()
        manager.GET(requestURL, parameters: nil, success: { (operation, data) -> Void in
            // stuff
            let immutableSchoolDict = (data as! NSDictionary)["school"] as! NSDictionary
            let schoolDict = immutableSchoolDict.mutableCopy()
            let userDict = schoolDict["users"] as! NSMutableArray
            schoolDict.removeObjectForKey("users")
            var schoolSwiftDict = [String: AnyObject]()
            for key in schoolDict.allKeys {
                schoolSwiftDict[key as! String] = schoolDict[key as! String]
            }
            let school = School(propertyDictionary: schoolSwiftDict)
            var students = [User]()
            for user in userDict {
                let userDict = user as! NSMutableDictionary
                var userSwiftDict = [String: AnyObject]()
                for key in userDict.allKeys {
                    userSwiftDict[key as! String] = userDict[key as! String]
                }
                let user = User(propertyDictionary: userSwiftDict)
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
            let userArray = data["users"] as! NSMutableArray
            for userDict in userArray {
                let dict = userDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let user = User(propertyDictionary: swiftDict)
                users.append(user)
            }
            completion(users)
            // handle the data and run success on an nsmutablearray
        }) { (operation, error) -> Void in
            failure(error.localizedDescription)
        }
    }
    
    static func createSchool(school: School, completion: ((School) -> Void)?, failure: (String) -> Void){
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
