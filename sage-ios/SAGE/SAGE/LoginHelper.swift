//
//  LoginHelper.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import SwiftKeychainWrapper
import AFNetworking

class LoginHelper: NSObject {
    static func userIsLoggedIn() -> Bool {
        if let _ = User.currentUser {
            return true
        }
        let retrievedUsername = KeychainWrapper.objectForKey(KeychainConstants.kVEmail)
        if let _ = retrievedUsername {
            return true
        }
        return false
    }
    
    static func userIsVerified(completion: ((Bool) -> Void)) {
        if let verified = KeychainWrapper.objectForKey(KeychainConstants.kVerified) {
            let verifiedBool = verified as! Bool
            if verifiedBool {
                completion(true)
            } else {
                if let verified = User.currentUser?.verified {
                    completion(verified)
                } else {
                    let email = KeychainWrapper.objectForKey(KeychainConstants.kVEmail) as? String
                    let password = KeychainWrapper.objectForKey(KeychainConstants.kVPassword) as? String
                    if (email != nil && password != nil) {
                        LoginHelper.isValidLogin(email!, password: password!, completion: { (success) -> Void in
                            if success && User.currentUser!.verified! {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        })
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            completion(false)
        }
    }
    
    static func storeUserDataInKeychain(firstName: String?, lastName: String?, email: String?, password: String?, school: Int?, hours: Int?, verified: Bool?) {
        if let firstName = firstName {
            KeychainWrapper.setObject(firstName, forKey: KeychainConstants.kVFirstName)
        }
        if let lastName = lastName {
            KeychainWrapper.setObject(lastName, forKey: KeychainConstants.kVLastName)
        }
        if let email = email {
            KeychainWrapper.setObject(email, forKey: KeychainConstants.kVEmail)
        }
        if let password = password {
            KeychainWrapper.setObject(password, forKey: KeychainConstants.kVPassword)
        }
        if let hours = hours {
            KeychainWrapper.setObject(hours, forKey: KeychainConstants.kVHours)
        }
        if let verified = verified {
            KeychainWrapper.setObject(verified, forKey: KeychainConstants.kVerified)
        }
    }
    
    static func createUser(firstName: String, lastName: String, email: String, password: String, school: Int, hours: Int, role: Int, photoData: String, completion: ((Bool) -> Void)) {
        
        let operationManager = AFHTTPRequestOperationManager()
        operationManager.requestSerializer = AFJSONRequestSerializer()
        operationManager.responseSerializer = AFJSONResponseSerializer()
        
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["user":
            [
                "first_name": firstName,
                "last_name": lastName,
                "email": email,
                "password": password,
                "role": role,
                "volunteer_type": hours,
                "data": photoData,
                "school_id": school // for now
            ]
        ]
        
        operationManager.POST(StringConstants.kEndpointCreateUser, parameters: params, success: { (operation, data) -> Void in
            let user = data["session"]!!["user"]!!
            
            var firstName, lastName: String?
            var hours: Int?
            if let fName = user[UserConstants.kFirstName] {
                firstName = fName as? String
            }
            if let lName = user[UserConstants.kLastName] {
                lastName = lName as? String
            }
            if let hoursString = user[UserConstants.kLevel] as? String {
                switch hoursString {
                case "two_units":
                    hours = User.VolunteerLevel.TwoUnit.rawValue
                case "one_unit":
                    hours = User.VolunteerLevel.OneUnit.rawValue
                case "volunteer":
                    hours = User.VolunteerLevel.ZeroUnit.rawValue
                default: break
                }
            }
            LoginHelper.storeUserDataInKeychain(firstName, lastName: lastName, email: email, password: password, school: nil, hours: hours, verified: nil)
            completion(true)
            
            }) { (operation, error) -> Void in
            completion(false)
        }
    }
    
    static func isValidLogin(email: String, password: String, completion: ((Bool) -> Void)) {
        
        
        let operationManager = AFHTTPRequestOperationManager()
        operationManager.requestSerializer = AFJSONRequestSerializer()
        operationManager.responseSerializer = AFJSONResponseSerializer()
        
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = [ "user": [
            "email": email,
            "password": password,
            ]
        ]
        
        operationManager.POST(StringConstants.kEndpointLogin, parameters: params, success: { (operation, data) -> Void in
            
            let userDict = data["session"]!!["user"]
            User.currentUser = User(propertyDictionary: userDict as! [String: AnyObject])
            LoginHelper.storeUserDataInKeychain(User.currentUser?.firstName, lastName: User.currentUser?.lastName, email: User.currentUser?.email, password: password, school: data["session"]??["school"]??[SchoolConstants.kId] as? Int, hours: User.currentUser?.level?.rawValue, verified: User.currentUser?.verified)
            completion(true)
            
            }) { (operation, error) -> Void in
                completion(false)
        }
    }
    
    static func isValidEmail(completion: (Bool) -> Void) {
        // check that it hasn't been taken already for new usernames
        let value: Bool = false
        completion(value)
    }
    
    static func getKeyChainData() -> [String: AnyObject] {
        var data: [String: AnyObject] = [String: AnyObject]()
        
        if let email = KeychainWrapper.objectForKey(KeychainConstants.kVEmail) {
            data[UserConstants.kEmail] = email
        }
        
        if let verified = KeychainWrapper.objectForKey(KeychainConstants.kVerified) {
            data[UserConstants.kVerified] = verified
        }
        
        return data
    }
    
    static func deleteKeychainData() {
        KeychainWrapper.removeObjectForKey(KeychainConstants.kVFirstName)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kVLastName)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kVEmail)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kVPassword)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kVHours)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kVerified)
    }
    
    static func setUserSingleton() {
        // set user singleton
        let data: [String: AnyObject] = getKeyChainData()
        // get some data from the backend
        User.currentUser = User(propertyDictionary: data)
    }
}
