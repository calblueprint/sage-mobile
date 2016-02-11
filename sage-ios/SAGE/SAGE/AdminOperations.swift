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
        if let currentSemester = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) as? Semester {
            let params = [UserConstants.kSemesterID: currentSemester.id]
            manager.GET(StringConstants.kEndpointGetMentors, parameters: params, success: { (operation, data) -> Void in
                var userArray = [User]()
                let userData = data["users"] as! [AnyObject]
                for userDict in userData {
                    let user = User(propertyDictionary: userDict as! [String: AnyObject])
                    userArray.append(user)
                }
                userArray.sortInPlace({ (user1, user2) -> Bool in
                    user1.isBefore(user2)
                })
                completion(userArray)
                }) { (operation, error) -> Void in
                    failure(BaseOperation.getErrorMessage(error))
            }
        } else {
            completion([])
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
            userArray.sortInPlace({ (user1, user2) -> Bool in
                user1.isBefore(user2)
            })
            completion(userArray)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
        
    }

    static func loadNonDirectorAdmins(completion: (([User]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        let params = [UserConstants.kNonDirector: true]
        manager.GET(StringConstants.kEndpointGetNonDirectorAdmin, parameters: params, success: { (operation, data) -> Void in
            var userArray = [User]()
            let userData = data["users"] as! [AnyObject]
            for userDict in userData {
                let user = User(propertyDictionary: userDict as! [String: AnyObject])
                userArray.append(user)
            }
            userArray.sortInPlace({ (user1, user2) -> Bool in
                user1.isBefore(user2)
            })
            completion(userArray)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
        
    }
    
    static func loadCheckinRequests(completion: (([Checkin]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        let params = [
            NetworkingConstants.kSortAttr: CheckinConstants.kTimeCreated,
            NetworkingConstants.kSortOrder: NetworkingConstants.kDescending
        ]
        manager.GET(StringConstants.kEndpointGetCheckins, parameters: params, success: { (operation, data) -> Void in
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

    
    static func loadSchools(completion: (([School]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetSchools, parameters: nil, success: { (operation, data) -> Void in
            var schools = [School]()
            let schoolArray = data["schools"] as! [AnyObject]
            for schoolDict in schoolArray {
                let school = School(propertyDictionary: schoolDict as! [String: AnyObject])
                schools.append(school)
            }
            schools.sortInPlace({ (school1, school2) -> Bool in
                school1.isBefore(school2)
            })
            completion(schools)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
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
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    
    static func loadSignUpRequests(completion: (([User]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        let params = [
            NetworkingConstants.kSortAttr: CheckinConstants.kTimeCreated,
            NetworkingConstants.kSortOrder: NetworkingConstants.kDescending
        ]
        manager.GET(StringConstants.kEndpointGetSignUpRequests, parameters: params, success: { (operation, data) -> Void in
            var users = [User]()
            let userArray = data["users"] as! [AnyObject]
            for userDict in userArray {
                let user = User(propertyDictionary: userDict as! [String : AnyObject])
                users.append(user)
            }
            completion(users)
        }) { (operation, error) -> Void in
            failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func createSchool(school: School, completion: ((School) -> Void)?, failure: (String) -> Void){
        
        var data: [String: AnyObject] = [
            SchoolConstants.kName: school.name!,
            SchoolConstants.kLat: school.location!.coordinate.latitude,
            SchoolConstants.kLong: school.location!.coordinate.longitude,
            SchoolConstants.kAddress: school.address!
            
        ]
        
        if school.director != nil {
            data[SchoolConstants.kDirectorID] = school.director!.id
        }
        
        let params = ["school": data]
        
        let manager = BaseOperation.manager()
        
        manager.POST(StringConstants.kEndpointCreateSchool, parameters: params, success: { (operation, data) -> Void in
            let schoolDict = data["school"] as! [String: AnyObject]
            let schoolResult = School(propertyDictionary: schoolDict)
            completion!(schoolResult)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func editSchool(school: School, completion: ((School) -> Void)?, failure: (String) -> Void){
        let manager = BaseOperation.manager()
        
        let params = ["school": [
                SchoolConstants.kLat: school.location!.coordinate.latitude,
                SchoolConstants.kLong: school.location!.coordinate.longitude,
                SchoolConstants.kName: school.name!,
                SchoolConstants.kDirectorID: school.director!.id,
                SchoolConstants.kAddress: school.address!
            ]
        ]
        let schoolURLString = StringConstants.kSchoolAdminDetailURL(school.id)
        
        manager.PATCH(schoolURLString, parameters: params, success: { (operation, data) -> Void in
//            let schoolDict = data["school"] as!
            completion!(school)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func editAnnouncement(announcement: Announcement, completion: ((Announcement) -> Void)?, failure: (String) -> Void){
        let manager = BaseOperation.manager()
        var params: [String: AnyObject]
        if announcement.school != nil && announcement.school!.id != -1 {
            params = ["announcement": [
                    AnnouncementConstants.kTitle: announcement.title!,
                    AnnouncementConstants.kText: announcement.text!,
                    AnnouncementConstants.kSchoolID: announcement.school!.id,
                    AnnouncementConstants.kCategory: Announcement.Category.School.rawValue
                ]
            ]
        } else {
            params = [
                "announcement": [
                    AnnouncementConstants.kTitle: announcement.title!,
                    AnnouncementConstants.kText: announcement.text!,
                    AnnouncementConstants.kSchoolID: 0,
                    AnnouncementConstants.kCategory: Announcement.Category.General.rawValue
                ]
            ]
        }

        let announcementURLString = StringConstants.kAnnouncementAdminDetailURL(announcement.id!)
        manager.PATCH(announcementURLString, parameters: params, success: { (operation, data) -> Void in
            completion!(announcement)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func approveCheckin(checkin: Checkin, completion: ((Checkin) -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        
        let checkinURLString = StringConstants.kCheckinAdminVerifyURL(checkin.id)
        
        manager.POST(checkinURLString, parameters: nil, success: { (operation, data) -> Void in
            let verifiedCheckinDict = data["check_in"] as! [String: AnyObject]
            let verifiedCheckin = Checkin(propertyDictionary: verifiedCheckinDict)
            completion?(verifiedCheckin)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func denyCheckin(checkin: Checkin, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let checkinURLString = StringConstants.kCheckinAdminDetailURL(checkin.id)
        
        manager.DELETE(checkinURLString, parameters: nil, success: { (operation, data) -> Void in
            completion?()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }

    }
    
    static func verifyUser(user: User, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()

        let userURLString = StringConstants.kUserAdminVerifyURL(user.id)
        manager.POST(userURLString, parameters: nil, success: { (operation, data) -> Void in
            completion?()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func denyUser(user: User, completion: (() -> Void)?, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let userURLString = StringConstants.kUserDetailURL(user.id)
        manager.DELETE(userURLString, parameters: nil, success: { (operation, data) -> Void in
            completion?()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func createAnnouncement(announcement: Announcement, completion: (Announcement) -> Void, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        var params = [String: AnyObject]()
        if announcement.school == nil || announcement.school!.id == -1 {
            params = ["announcement":
                [
                    AnnouncementConstants.kTitle: announcement.title!,
                    AnnouncementConstants.kText: announcement.text!,
                    AnnouncementConstants.kUserID: LoginOperations.getUser()!.id,
                    AnnouncementConstants.kCategory: Announcement.Category.General.rawValue
                ]
            ]
        } else {
            params = ["announcement":
                [
                    AnnouncementConstants.kTitle: announcement.title!,
                    AnnouncementConstants.kText: announcement.text!,
                    AnnouncementConstants.kSchoolID: announcement.school!.id,
                    AnnouncementConstants.kUserID: LoginOperations.getUser()!.id,
                    AnnouncementConstants.kCategory: Announcement.Category.School.rawValue
                ]
            ]
        }
        
        manager.POST(StringConstants.kEndpointCreateAnnouncement, parameters: params, success: { (operation, data) -> Void in
            let announcementDict = (data as! [String: AnyObject])["announcement"] as! [String: AnyObject]
            let createdAnnouncement = Announcement(properties: announcementDict)
            completion(createdAnnouncement)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
}
