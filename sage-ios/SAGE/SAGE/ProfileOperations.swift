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
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func loadCheckins(user: User, completion: (([Checkin]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        let currentSemesterID = (KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) as? Semester)?.id
        if let semesterID = currentSemesterID {
            let params = [
                SemesterConstants.kSemesterId: semesterID,
                NetworkingConstants.kSortAttr: CheckinConstants.kTimeCreated,
                NetworkingConstants.kSortOrder: NetworkingConstants.kDescending,
                CheckinConstants.kUserId: user.id
            ]
            manager.GET(StringConstants.kEndpointCheckin, parameters: params, success: { (operation, data) -> Void in
                var checkins = [Checkin]()
                let checkinArray = data["check_ins"] as! [AnyObject]
                for checkinDict in checkinArray {
                    let checkin = Checkin(propertyDictionary: checkinDict as! [String : AnyObject])
                    checkins.append(checkin)
                }
                completion(checkins)
                
                }) { (operation, error) -> Void in
                    failure(BaseOperation.getErrorMessage(error))
            }
        }
        completion([])
    }
    
    static func updateProfile(user: User, password: String, photoData: String?, newPassword: String?, passwordConfirmation: String?, resetPhoto: Bool, completion: (User) -> Void, failure: (String) -> Void) {
        let manager = BaseOperation.manager()

        var hours: Int = 0
        switch user.level {
        case .ZeroUnit: hours = 0
        case .OneUnit: hours = 1
        case .TwoUnit: hours = 2
        default: hours = 0
        }
        
        var userJSON: [String: AnyObject] = [
            UserConstants.kFirstName: user.firstName!,
            UserConstants.kLastName: user.lastName!,
            UserConstants.kEmail: user.email!,
            UserConstants.kLevel: hours,
            UserConstants.kSchoolID: user.school!.id,
            UserConstants.kCurrentPassword: password,
        ]
        
        if photoData != nil {
            userJSON[UserConstants.kPhotoData] = photoData!
        }

        if resetPhoto {
            userJSON[UserConstants.kRemoveImage] = true
        }

        if newPassword != nil {
            userJSON[UserConstants.kPassword] = newPassword!
            userJSON[UserConstants.kPasswordConfirmation] = passwordConfirmation
        }

        let params = ["user": userJSON]

        let updateProfileURLString = StringConstants.kUserDetailURL(user.id)
        
        manager.PATCH(updateProfileURLString, parameters: params, success: { (operation, data) -> Void in
            let newUserData = (data as! [String: AnyObject])["user"] as! [String: AnyObject]
            let newUser = User(propertyDictionary: newUserData)
            LoginOperations.storeUserDataInKeychain(newUser)
            completion(newUser)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
        
    }
    
    static func promote(user: User, role: User.UserRole, completion: ((User) -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let url = StringConstants.kUserAdminPromoteURL(user.id)

        let params = ["user":
            [
                UserConstants.kRole: role.rawValue
            ]
        ]
        
        manager.POST(url, parameters: params, success: { (operation, data) -> Void in
            let userDict = (data as! [String: AnyObject])["user"] as! [String: AnyObject]
            let user = User(propertyDictionary: userDict)
            completion?(user)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func demote(user: User, completion: ((User) -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let url = StringConstants.kUserAdminPromoteURL(user.id)
        
        let params = ["user":
            [
                UserConstants.kRole: 0
            ]
        ]
        
        manager.POST(url, parameters: params, success: { (operation, data) -> Void in
            let userDict = (data as! [String: AnyObject])["user"] as! [String: AnyObject]
            let user = User(propertyDictionary: userDict)
            completion?(user)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
}