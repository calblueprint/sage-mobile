//
//  LoginOperations.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import SwiftKeychainWrapper
import AFNetworking

class LoginOperations: NSObject {
    static func userIsLoggedIn() -> Bool {
        if let _ = KeychainWrapper.objectForKey(KeychainConstants.kUser) {
            return true
        } else {
            return false
        }
    }
    
    static func getUser() -> User? {
        return KeychainWrapper.objectForKey(KeychainConstants.kUser) as? User
    }
    
    static func getState(completion: ((User, Semester?, SemesterSummary?) -> Void), failure:((String) -> Void)) {
        BaseOperation.manager().GET(StringConstants.kEndpointUserState(LoginOperations.getUser()!), parameters: nil, success: { (operation, data) -> Void in
            KeychainWrapper.removeObjectForKey(KeychainConstants.kCurrentSemester)
            KeychainWrapper.removeObjectForKey(KeychainConstants.kSemesterSummary)
            KeychainWrapper.removeObjectForKey(KeychainConstants.kUser)
            let userJSON = data["session"]!!["user"] as! [String: AnyObject]
            let user = User(propertyDictionary: userJSON)
            KeychainWrapper.setObject(user, forKey: KeychainConstants.kUser)
            let currentSemesterJSON = data["session"]!!["current_semester"]
            var currentSemester: Semester? = nil
            if !(currentSemesterJSON is NSNull) {
                currentSemester = Semester(propertyDictionary: currentSemesterJSON as! [String: AnyObject])
            }
            let semesterSummaryJSON = userJSON["user_semester"]
            var semesterSummary: SemesterSummary? = nil
            if !(semesterSummaryJSON is NSNull) {
                semesterSummary = SemesterSummary(propertyDictionary: semesterSummaryJSON as! [String: AnyObject])
            }
            if (currentSemester != nil) {
                KeychainWrapper.setObject(currentSemester!, forKey: KeychainConstants.kCurrentSemester)
            }
            if (semesterSummary != nil) {
                KeychainWrapper.setObject(semesterSummary!, forKey: KeychainConstants.kSemesterSummary)
            }
            completion(user, currentSemester, semesterSummary)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func verifyUser(completion: ((Bool) -> Void)) {
        if let user = KeychainWrapper.objectForKey(KeychainConstants.kUser) as? User {
            if user.verified {
                completion(true)
            } else {
                let email = user.email
                let authToken = (KeychainWrapper.objectForKey(KeychainConstants.kAuthToken) as? String)
                if (email != nil && authToken != nil) {
                    LoginOperations.loginWith(email!, authToken: authToken!, completion: { (success) -> Void in
                        if success && (KeychainWrapper.objectForKey(KeychainConstants.kUser) as! User).verified {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                } else {
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
    
    static func updateUserRoleInKeychain(role: User.UserRole) -> User {
        let existingUser = KeychainWrapper.objectForKey(KeychainConstants.kUser) as! User
        existingUser.role = role
        KeychainWrapper.setObject(existingUser, forKey: KeychainConstants.kUser)
        return existingUser
    }
    
    static func storeUserDataInKeychain(user: User, authToken: String? = nil) {
        if let existingUser = (KeychainWrapper.objectForKey(KeychainConstants.kUser) as? User) {
            if -1 != user.id {
                existingUser.id = user.id
            }
            if let firstName = user.firstName {
                existingUser.firstName = firstName
            }
            if let lastName = user.lastName {
                existingUser.lastName = lastName
            }
            if let email = user.email {
                existingUser.email = email
            }
            if let school = user.school {
                existingUser.school = school
                KeychainWrapper.setObject(school, forKey: KeychainConstants.kSchool)
            }
            if User.VolunteerLevel.Default != user.level {
                existingUser.level = user.level
            }
            if User.UserRole.Default != user.role {
                existingUser.role = user.role
            }
            existingUser.semesterSummary = user.semesterSummary
            existingUser.verified = user.verified
            KeychainWrapper.setObject(existingUser, forKey: KeychainConstants.kUser)
        } else {
            KeychainWrapper.setObject(user, forKey: KeychainConstants.kUser)
            if let auth = authToken {
                KeychainWrapper.setObject(auth, forKey: KeychainConstants.kAuthToken)
            }
            if let school = user.school {
                user.school = school
                KeychainWrapper.setObject(school, forKey: KeychainConstants.kSchool)
            }
        }
    }
    
    static func createUser(firstName: String, lastName: String, email: String, password: String, school: Int, hours: Int, photoData: String, completion: ((Bool) -> Void)) {
        
        let operationManager = AFHTTPRequestOperationManager()
        operationManager.requestSerializer = AFJSONRequestSerializer()
        operationManager.responseSerializer = AFJSONResponseSerializer()
        
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["user":
            [
                UserConstants.kFirstName: firstName,
                UserConstants.kLastName: lastName,
                UserConstants.kEmail: email,
                UserConstants.kPassword: password,
                UserConstants.kLevel: hours,
                UserConstants.kPhotoData: photoData,
                UserConstants.kSchoolID: school
            ]
        ]
        
        operationManager.POST(StringConstants.kEndpointCreateUser, parameters: params, success: { (operation, data) -> Void in
            let userDict = data["session"]!!["user"]!!
            let user = User(propertyDictionary: userDict as! [String: AnyObject])
            let authToken = data["session"]!![UserConstants.kAuthToken] as! String
            let schoolDictionary = data["session"]!!["school"]!!
            let school = School(propertyDictionary: schoolDictionary as! [String : AnyObject])
            user.school = school
            
            LoginOperations.storeUserDataInKeychain(user, authToken: authToken)
            completion(true)
            
            }) { (operation, error) -> Void in
                completion(false)
        }
    }
    
    // This function gets called every time the rootController is allocated and updates user 
    // keychain data as necessary
    static func loginWith(email: String, authToken: String? = nil, password: String? = nil, completion: ((Bool) -> Void)) {
        
        
        let operationManager = BaseOperation.manager()
        
        operationManager.requestSerializer = AFJSONRequestSerializer()
        operationManager.responseSerializer = AFJSONResponseSerializer()
        
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var params: [String: AnyObject]
        if let _ = authToken {
            params = [
                "user": ["email": email],
            ]
        } else {
            params = [ "user": [
                "email": email,
                "password": password!,
                ]
            ]
        }
        
        operationManager.POST(StringConstants.kEndpointLogin, parameters: params, success: { (operation, data) -> Void in
            
            let userDict = data["session"]!!["user"]!!
            let user = User(propertyDictionary: userDict as! [String: AnyObject])
            let authToken = data["session"]!![UserConstants.kAuthToken] as! String
            let schoolDictionary = data["session"]!!["school"]!!
            let school = School(propertyDictionary: schoolDictionary as! [String : AnyObject])
            user.school = school
            
            LoginOperations.storeUserDataInKeychain(user, authToken: authToken)
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
    
    static func deleteUserKeychainData() {
        KeychainWrapper.removeObjectForKey(KeychainConstants.kUser)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kAuthToken)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kSchool)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kCurrentSemester)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kSemesterSummary)
        KeychainWrapper.removeObjectForKey(KeychainConstants.kSessionStartTime)
    }
}
