//
//  StringConstants.swift
//  SAGE
//
//  Created by Andrew on 10/1/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

struct StringConstants {
    
    static let kBaseURL = "SAGE"
    static let displayDateFormat = "yyyy/MM/dd hh:mm a"
    static let JSONdateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    static let kEndpointBaseURL = "http://sage-rails.herokuapp.com/api/v1"
    // static let kEndpointBaseURL = "http://localhost:3000/api/v1"
    static let kEndpointCreateUser = kEndpointBaseURL + "/users"
    static let kEndpointLogin = kEndpointBaseURL + "/users/sign_in"
    static let kEndpointLogout = kEndpointBaseURL + "/users/sign_out"
    static let kEndpointSchool = kEndpointBaseURL + "/schools"
    static let kEndpointCreateSchool = kEndpointBaseURL + "/admin/schools"
    static let kEndpointCheckin = kEndpointBaseURL + "/check_ins"
    static let kEndpointAnnouncements = kEndpointBaseURL + "/announcements"
    static let kEndpointCreateAnnouncement = kEndpointBaseURL + "/admin/announcements"


    static let kEndpointGetMentors = kEndpointBaseURL + "/users?verified=true"
    static let kEndpointGetAdmins = kEndpointBaseURL + "/users?role=1"
    static let kEndpointGetNonDirectorAdmin = kEndpointBaseURL + "/users?role=1,non_director=true"
    static let kEndpointGetCheckins = kEndpointBaseURL + "/check_ins?verified=false"
    static let kEndpointGetSchools = kEndpointBaseURL + "/schools?"
    static let kEndpointGetSignUpRequests = kEndpointBaseURL + "/users?verified=false"
    
    static func kSchoolDetailURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/schools/" + String(id)
    }
    
    static func kSchoolAdminDetailURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/admin/schools/" + String(id)
    }
    
    static func kCheckinDetailURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/check_ins/" + String(id)
    }
    
    static func kCheckinAdminDetailURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/admin/check_ins/" + String(id)
    }
    
    static func kCheckinAdminVerifyURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/admin/check_ins/" + String(id) + "/verify"
    }
    
    static func kUserAdminVerifyURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/admin/users/" + String(id) + "/verify"
    }
    
    static func kUserDetailURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/users/" + String(id)
    }
    
    static func kUserAdminDetailURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/admin/users/" + String(id)
    }
    
    static func kAnnouncementDetailURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/announcements/" + String(id)
    }
    
    static func kAnnouncementAdminDetailURL(id: Int) -> String {
        return StringConstants.kEndpointBaseURL + "/admin/announcements/" + String(id)
    }
}