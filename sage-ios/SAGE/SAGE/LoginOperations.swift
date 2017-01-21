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
    
    static func getState(completion: ((User, Semester?, SemesterSummary?) -> Void), failure:((String) -> Void)) {
        BaseOperation.manager().GET(StringConstants.kEndpointUserState(SAGEState.currentUser()!), parameters: nil, success: { (operation, data) -> Void in
            SAGEState.removeCurrentSemester()
            SAGEState.removeSemesterSummary()
            
            let userJSON = data["session"]!!["user"] as! [String: AnyObject]
            let user = User(propertyDictionary: userJSON)
            SAGEState.setCurrentUser(user)
            
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
            
            let schoolJSON = data["session"]!!["school"]
            var school: School? = nil
            if !(schoolJSON is NSNull) {
                school = School(propertyDictionary: schoolJSON as! [String: AnyObject])
            }
            if (currentSemester != nil) {
                SAGEState.setCurrentSemester(currentSemester!)
            }
            if (semesterSummary != nil) {
                SAGEState.setSemesterSummary(semesterSummary!)
            }
            if (school != nil) {
                SAGEState.setCurrentSchool(school!)
            }
            
            let checkinRequests = data["session"]!!["check_in_requests"]
            if let checkinCount = checkinRequests as? Int {
                SAGEState.setCheckinRequestCount(checkinCount)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.updateCheckinRequestCountKey, object: checkinCount)
            }
            
            let signUpRequests = data["session"]!!["sign_up_requests"]
            if let signUpCount = signUpRequests as? Int {
                SAGEState.setSignUpRequestCount(signUpCount)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.updateSignupRequestCountKey, object: signUpCount)
            }
            
            completion(user, currentSemester, semesterSummary)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func verifyUser(completion: ((Bool) -> Void)) {
        if let user = SAGEState.currentUser() {
            if user.verified {
                completion(true)
            } else {
                let email = user.email
                let authToken = SAGEState.authToken()
                if (email != nil && authToken != nil) {
                    LoginOperations.loginWith(email!, authToken: authToken!, completion: { (success) -> Void in
                        if success && SAGEState.currentUser()!.verified {
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
    
    static func createUser(firstName: String, lastName: String, email: String, password: String, school: Int, hours: Int, photoData: String?, completion: ((Bool) -> Void)) {
        
        let operationManager = AFHTTPRequestOperationManager()
        operationManager.requestSerializer = AFJSONRequestSerializer()
        operationManager.responseSerializer = AFJSONResponseSerializer()
        
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var data: [String: AnyObject] = [
            UserConstants.kFirstName: firstName,
            UserConstants.kLastName: lastName,
            UserConstants.kEmail: email,
            UserConstants.kPassword: password,
            UserConstants.kLevel: hours,
            UserConstants.kSchoolID: school
        ]
        if photoData != nil {
            data[UserConstants.kPhotoData] = photoData!
        }
        
        let params = ["user": data]
        
        operationManager.POST(StringConstants.kEndpointCreateUser, parameters: params, success: { (operation, data) -> Void in
            let userDict = data["session"]!!["user"]!!
            let user = User(propertyDictionary: userDict as! [String: AnyObject])
            let authToken = data["session"]!![UserConstants.kAuthToken] as! String
            let schoolDictionary = data["session"]!!["school"]!!
            let school = School(propertyDictionary: schoolDictionary as! [String : AnyObject])
            user.school = school
            
            SAGEState.setCurrentUser(user)
            SAGEState.setAuthToken(authToken)
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
            if !(schoolDictionary is NSNull) {
                let school = School(propertyDictionary: schoolDictionary as! [String : AnyObject])
                user.school = school
            }
            
            SAGEState.setCurrentUser(user)
            SAGEState.setAuthToken(authToken)
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
    
    static func sendPasswordResetRequest(email: String, completion: (() -> Void), failure: (String) -> Void) {
        let operationManager = BaseOperation.manager()
        var params = [String: AnyObject]()
        params[NetworkingConstants.kEmail] = email
        
        operationManager.POST(StringConstants.kEndpointPasswordReset, parameters: params, success: { (operation, object) -> Void in
            completion()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
}
