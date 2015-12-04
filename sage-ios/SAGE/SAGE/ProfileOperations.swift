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
    static func userIsLoggedIn() -> Bool {
        if let _ = KeychainWrapper.objectForKey(KeychainConstants.kUser) {
            return true
        } else {
            return false
        }
    }
    
    static func getUser(completion: ((User) -> Void), failure:((String) -> Void)) {
        BaseOperation.manager().GET(StringConstants.kEndpointUser(LoginOperations.getUser()!), parameters: nil, success: { (operation, data) -> Void in
            let userJSON = data["user"]!! as! [String: AnyObject]
            let user = User(propertyDictionary: userJSON)
            completion(user)
            }) { (operation, error) -> Void in
                failure("Cannot get user")
        }
    }
    
    static func loadCheckinRequests(completion: (([Checkin]) -> Void), failure: (String) -> Void){
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
}