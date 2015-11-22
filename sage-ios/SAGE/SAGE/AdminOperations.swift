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
    
    static func loadMentors(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetMentors, parameters: nil, success: { (operation, data) -> Void in
            let userArray = NSMutableArray()
            let userData = ((data as! NSMutableDictionary)["users"] as! NSMutableArray)
            for userDict in userData {
                let dict = userDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let user = User(propertyDictionary: swiftDict)
                userArray.addObject(user)
            }
            completion(userArray)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func loadDirectors(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetUsers, parameters: nil, success: { (operation, data) -> Void in
            let userArray = NSMutableArray()
            let userData = ((data as! NSMutableDictionary)["users"] as! NSMutableArray)
            for userDict in userData {
                let dict = userDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let user = User(propertyDictionary: swiftDict)
                userArray.addObject(user)
            }
            completion(userArray)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func loadCheckinRequests(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetCheckins, parameters: nil, success: { (operation, data) -> Void in
            // handle the data and run success on an nsmutablearray
            let checkins = NSMutableArray()
            let checkinArray = (data as! NSMutableDictionary)["check_ins"] as! NSMutableArray
            for checkinDict in checkinArray {
                let dict = checkinDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let checkin = Checkin(propertyDictionary: swiftDict)
                checkins.addObject(checkin)

            }
            completion(checkins)

            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
    }
    
    static func loadSchools(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetSchools, parameters: nil, success: { (operation, data) -> Void in
            let schools = NSMutableArray()
            let schoolArray = data["schools"] as! NSMutableArray
            for schoolDict in schoolArray {
                let dict = schoolDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let school = School(propertyDictionary: swiftDict)
                schools.addObject(school)
            }
            completion(schools)
            // handle the data and run success on an nsmutablearray
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    
    static func loadSignUpRequests(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetSignUpRequests, parameters: nil, success: { (operation, data) -> Void in
            let users = NSMutableArray()
            let userArray = data["users"] as! NSMutableArray
            for userDict in userArray {
                let dict = userDict as! NSMutableDictionary
                var swiftDict = [String: AnyObject]()
                for key in dict.allKeys {
                    swiftDict[key as! String] = dict[key as! String]
                }
                let user = User(propertyDictionary: swiftDict)
                users.addObject(user)
            }
            completion(users)
            // handle the data and run success on an nsmutablearray
        }) { (operation, error) -> Void in
            failure(error.localizedDescription)
        }
        
    }
    
}
