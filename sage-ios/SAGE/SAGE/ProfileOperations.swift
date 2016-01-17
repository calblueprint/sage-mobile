//
//  ProfileOperations.swift
//  SAGE
//
//  Created by Erica Yin on 11/29/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import SwiftKeychainWrapper
import AFNetworking

class ProfileOperations: NSObject { 
    static func getUser(user: User, completion: ((User) -> Void), failure:((String) -> Void)) {
        BaseOperation.manager().GET(StringConstants.kEndpointUser(user), parameters: nil, success: { (operation, data) -> Void in
            let userJSON = data["user"]!! as! [String: AnyObject]
            let user = User(propertyDictionary: userJSON)
            completion(user)
            }) { (operation, error) -> Void in
                failure("Cannot get user")
        }
    }
    
    static func loadCheckins(completion: (([Checkin]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointUserCheckins(LoginOperations.getUser()!), parameters: nil, success: { (operation, data) -> Void in
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
    
    static func updateProfile(user: User, completion: (User) -> Void, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        
        var hours = 0
        switch user.level {
        case .ZeroUnit: hours = 0
        case .OneUnit: hours = 1
        case .TwoUnit: hours = 2
        default: hours = 0
        }
        
        let params = [
            UserConstants.kFirstName: user.firstName!,
            UserConstants.kLastName: user.lastName!,
            UserConstants.kEmail: user.email!,
            UserConstants.kLevel: hours,
            UserConstants.kSchoolID: user.school!.id,
        ]
        
        let updateProfileURLString = StringConstants.kUserDetailURL(user.id)
        
        manager.PATCH(updateProfileURLString, parameters: params, success: { (operation, data) -> Void in
            completion(user)
            }) { (operation, error) -> Void in
                failure("Could not edit profile.")
        }
        
    }
}