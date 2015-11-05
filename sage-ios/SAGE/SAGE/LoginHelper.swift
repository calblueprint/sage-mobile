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
    
    static func userIsVerified(completion: ((Bool) -> Void)) {
        // this returns only true for now because it hasn't been connected to the backend
        if let verified = KeychainWrapper.objectForKey(KeychainConstants.kVerified) {
            let verifiedBool = verified as! Bool
            if verifiedBool {
                completion(true)
            } else {
                // TODO: make network request to check whether a user is verified
                
            }
        }
        completion(false)
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
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (urlResponse, data, error) -> Void in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func isValidLogin(email: String, password: String, completion: ((Bool) -> Void)) {
        let url = NSURL(string: StringConstants.kEndpointLogin)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let params = [ "user": [
                        "email": email,
                        "password": password,
                        ]
                    ]
        if let body = try? NSJSONSerialization.dataWithJSONObject(params, options: []) {
            request.HTTPBody = body
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (urlResponse, data, error) -> Void in
            // TODO: make sure to check later if the data is right (actual valid login check)
            if error == nil {
                let userJson = try? NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let userDict = userJson!["session"]!!["user"]
                User.currentUser = User(propertyDictionary: userDict as! [String: AnyObject])
                LoginHelper.storeUserDataInKeychain(User.currentUser?.firstName, lastName: User.currentUser?.lastName, email: User.currentUser?.email, password: password, school: userJson!["session"]??["school"]??[SchoolConstants.kId] as? Int, hours: User.currentUser?.level?.rawValue, verified: User.currentUser?.verified)
                completion(true)
            } else {
                completion(false)
            }
        }
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
