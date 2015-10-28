//
//  LoginHelper.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import SwiftKeychainWrapper

class LoginHelper: NSObject {
    static func userIsLoggedIn() -> Bool {
        if let _ = User.currentUser {
            return true
        }
        let retrievedUsername: String? = KeychainWrapper.stringForKey(KeychainConstants.kEmail)
        if let _ = retrievedUsername {
            return true
        }
        return false
    }
    
    static func userIsVerified() -> Bool {
        // this returns only true for now because it hasn't been connected to the backend
        if let verified = KeychainWrapper.objectForKey(KeychainConstants.kVerified) {
            return verified as! Bool
        }
        return false
    }
    
    static func storeUserDataInKeychain(firstName: String, lastName: String, email: String, password: String, school: Int, hours: Int, verified: Bool) {
        KeychainWrapper.setObject(firstName, forKey: KeychainConstants.kVFirstName)
        KeychainWrapper.setObject(lastName, forKey: KeychainConstants.kVLastName)
        KeychainWrapper.setObject(email, forKey: KeychainConstants.kVEmail)
        KeychainWrapper.setObject(password, forKey: KeychainConstants.kVPassword)
        KeychainWrapper.setObject(school, forKey: KeychainConstants.kVSchool)
        KeychainWrapper.setObject(hours, forKey: KeychainConstants.kVHours)
        KeychainWrapper.setObject(verified, forKey: KeychainConstants.kVerified)
    }
    
    static func createUser(firstName: String, lastName: String, email: String, password: String, school: Int, hours: Int, role: Int, photoData: String, completion: ((Bool) -> Void)) {
        let url = NSURL(string: StringConstants.kEndpointCreateUser)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
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
        if let body = try? NSJSONSerialization.dataWithJSONObject(params, options: []) {
            request.HTTPBody = body
        }
        
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (urlResponse, data, error) -> Void in
            // nothing
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func isValidLogin(email: String, password: String, completion: ((Bool) -> Void)?) {
        let value: Bool = true
        completion?(value)
    }
    
    static func isValidEmail(completion: (Bool) -> Void) {
        // check that it hasn't been taken already for new usernames
        let value: Bool = false
        completion(value)
    }
    
    static func getKeyChainData() -> [String: AnyObject] {
        var data: [String: AnyObject] = [String: AnyObject]()
        
        if let email = KeychainWrapper.stringForKey(KeychainConstants.kEmail) {
            data[UserConstants.kEmail] = email
        }
        
        if let verified = KeychainWrapper.objectForKey(KeychainConstants.kVerified) {
            data[UserConstants.kVerified] = verified
        }
        
        return data
    }
    
    static func setUserSingleton() {
        // set user singleton
        let data: [String: AnyObject] = getKeyChainData()
        // get some data from the backend
        User.currentUser = User(propertyDictionary: data)
        
    }
}
