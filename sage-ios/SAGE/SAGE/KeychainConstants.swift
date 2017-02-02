//
//  KeychainConstants.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

struct KeychainConstants {

    //
    // MARK:- Verification
    //
    static let kAuthToken: String = StringConstants.kBaseURL + "authToken"
    static let kUser: String = StringConstants.kBaseURL + "User"
    
    static let kSessionStartTime: String = "Session Start Time"
    static let kSchool: String = "User School"
    
    static let kCurrentSemester: String = "Current Semester"
    static let kSemesterSummary: String = "Semester Summary"
    
    static let kSignUpRequests: String = "SignUpRequests"
    static let kCheckInRequests: String = "CheckInRequests"
    
    static let kLocationNotification: String = "LocationNotification"
    
    
}
