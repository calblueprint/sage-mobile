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
    
    static func loadMentors(completion: (([User]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetMentors, parameters: nil, success: { (operation, data) -> Void in
            var userArray = [User]()
            let userData = data["users"] as! [AnyObject]
            for userDict in userData {
                let user = User(propertyDictionary: userDict as! [String: AnyObject])
                userArray.append(user)
            }
            completion(userArray)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func loadAdmins(completion: (([User]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetAdmins, parameters: nil, success: { (operation, data) -> Void in
            var userArray = [User]()
            let userData = data["users"] as! [AnyObject]
            for userDict in userData {
                let user = User(propertyDictionary: userDict as! [String: AnyObject])
                userArray.append(user)
            }
            completion(userArray)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
            
    static func loadCheckinRequests(completion: (([Checkin]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetCheckins, parameters: nil, success: { (operation, data) -> Void in
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

    
    static func loadSchools(completion: (([School]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetSchools, parameters: nil, success: { (operation, data) -> Void in
            var schools = [School]()
            let schoolArray = data["schools"] as! [AnyObject]
            for schoolDict in schoolArray {
                let school = School(propertyDictionary: schoolDict as! [String: AnyObject])
                schools.append(school)
            }
            completion(schools)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func loadSchool(id: Int, completion: ((School) -> Void), failure: (String) -> Void) {
        let requestURL = StringConstants.kSchoolDetailURL(id)
        let manager = BaseOperation.manager()
        manager.GET(requestURL, parameters: nil, success: { (operation, data) -> Void in
            var schoolDict = data["school"] as! [String: AnyObject]
            let userDict = schoolDict["users"] as! [AnyObject]
            schoolDict.removeValueForKey("users")
            let school = School(propertyDictionary: schoolDict)
            var students = [User]()
            for user in userDict {
                let user = User(propertyDictionary: user as! [String: AnyObject])
                students.append(user)
            }
            school.students = students
            completion(school)
            
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
    }
    
    
    static func loadSignUpRequests(completion: (([User]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetSignUpRequests, parameters: nil, success: { (operation, data) -> Void in
            var users = [User]()
            let userArray = data["users"] as! [AnyObject]
            for userDict in userArray {
                let user = User(propertyDictionary: userDict as! [String : AnyObject])
                users.append(user)
            }
            completion(users)
        }) { (operation, error) -> Void in
            failure(error.localizedDescription)
        }
    }
    
    static func createSchool(school: School, completion: ((School) -> Void)?, failure: (String) -> Void){
        let params = ["school":
            [
                SchoolConstants.kName: school.name!,
                SchoolConstants.kLat: school.location!.coordinate.latitude,
                SchoolConstants.kLong: school.location!.coordinate.longitude,
                SchoolConstants.kAddress: school.address!,
                SchoolConstants.kDirectorID: school.director!.directorID
            ]
        ]
        
        let manager = BaseOperation.manager()
        
        manager.POST(StringConstants.kEndpointCreateSchool, parameters: params, success: { (operation, data) -> Void in
            let schoolDict = data["school"] as! [String: AnyObject]
            let school = School(propertyDictionary: schoolDict)
            completion!(school)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
    }
    
    static func editSchool(school: School, completion: ((School) -> Void)?, failure: (String) -> Void){
        let manager = BaseOperation.manager()
        
        let params = [
            SchoolConstants.kLat: school.location!.coordinate.latitude,
            SchoolConstants.kLong: school.location!.coordinate.longitude,
            SchoolConstants.kAddress: school.address!,
            SchoolConstants.kName: school.name!,
            SchoolConstants.kDirectorID: school.director!.id
        ]
        let schoolURLString = StringConstants.kSchoolDetailURL(school.id)
        
        manager.PATCH(schoolURLString, parameters: params, success: { (operation, data) -> Void in
            completion!(school)
            }) { (operation, error) -> Void in
                failure("Could not edit school.")
        }
    }
    
    static func editAnnouncement(announcement: Announcement, completion: ((Announcement) -> Void)?, failure: (String) -> Void){
        let manager = BaseOperation.manager()
        let params = [
                AnnouncementConstants.kTitle: announcement.title!,
                AnnouncementConstants.kText: announcement.text!,
                AnnouncementConstants.kSchoolID: announcement.school!.id,
        ]
        let announcementURLString = StringConstants.kAnnouncementDetailURL(announcement.id!)
        manager.PATCH(announcementURLString, parameters: params, success: { (operation, data) -> Void in
            completion!(announcement)
            }) { (operation, error) -> Void in
                failure("Could not edit announcement.")
        }
    }
    
    static func approveCheckin(checkin: Checkin, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        
        let params = [CheckinConstants.kVerified: true]
        let checkinURLString = StringConstants.kCheckinDetailURL(checkin.id)
        
        manager.PATCH(checkinURLString, parameters: params, success: { (operation, data) -> Void in
            completion!()
            }) { (operation, error) -> Void in
                failure("Could not approve checkin.")
        }
    }
    
    static func removeCheckin(checkin: Checkin, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let checkinURLString = StringConstants.kCheckinDetailURL(checkin.id)
        manager.DELETE(checkinURLString, parameters: nil, success: { (operation, data) -> Void in
            completion!()
            }) { (operation, error) -> Void in
                failure("Could not remove checkin.")
        }

    }
    
    static func verifyUser(user: User, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let params = [UserConstants.kVerified: true]
        let userURLString = StringConstants.kUserDetailURL(user.id)
        manager.PATCH(userURLString, parameters: params, success: { (operation, data) -> Void in
            completion!()
            }) { (operation, error) -> Void in
                failure("Couldn't verify user.")
        }
    }
    
    static func removeUser(user: User, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let userURLString = StringConstants.kUserDetailURL(user.id)
        manager.DELETE(userURLString, parameters: nil, success: { (operation, data) -> Void in
            completion!()
            }) { (operation, error) -> Void in
                failure("Could not remove user.")
        }
    }
    
    static func createAnnouncement(announcement: Announcement, completion: (Announcement) -> Void, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let params = ["announcement":
            [
                AnnouncementConstants.kTitle: announcement.title!,
                AnnouncementConstants.kText: announcement.text!,
                AnnouncementConstants.kSchoolID: announcement.school!.id,
                AnnouncementConstants.kUserID: LoginOperations.getUser()!.id,
                AnnouncementConstants.kCategory: "school"
            ]
        ]
        
        manager.POST(StringConstants.kEndpointCreateAnnouncement, parameters: params, success: { (operation, data) -> Void in
            let announcementDict = (data as! [String: AnyObject])["announcement"] as! [String: AnyObject]
            let createdAnnouncement = Announcement(properties: announcementDict)
            completion(createdAnnouncement)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
    }
    
}
