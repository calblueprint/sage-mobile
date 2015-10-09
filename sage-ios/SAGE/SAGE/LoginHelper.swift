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
        // also needs to create a user singleton
        if let _ = KeychainWrapper.stringForKey(KeychainConstants.kVerified) {
            return true
        }
        return false
    }
    
    func isValidLogin(completion: (Bool) -> Void) {
        let value: Bool = false
        completion(value)
    }
    
    func isValidUsername(completion: (Bool) -> Void) {
        // check that it hasn't been taken already for new usernames
        let value: Bool = false
        completion(value)
    }
    
    static func getKeyChainData() -> [String: String] {
        var data: [String: String] = [String: String]()
        
        if let email = KeychainWrapper.stringForKey(KeychainConstants.kEmail) {
            data[UserConstants.kEmail] = email
        }
        
        if let verified = KeychainWrapper.stringForKey(KeychainConstants.kVerified) {
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
