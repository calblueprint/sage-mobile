//
//  KeychainConstants.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

struct KeychainConstants {

    static let kAuthToken: String = StringConstants.kBaseURL + "authToken"
    static let kEmail: String = StringConstants.kBaseURL + "email"
    static let kVerified: String = StringConstants.kBaseURL + "verified"
    
    // string constants for stored data for request verification
    static let kVerificationBaseURL = StringConstants.kBaseURL + "Verification"
    static let kVFirstName: String = KeychainConstants.kVerificationBaseURL + "FirstName"
    static let kVLastName: String = KeychainConstants.kVerificationBaseURL + "LastName"
    static let kVEmail: String = KeychainConstants.kVerificationBaseURL + "Email"
    static let kVPassword: String = KeychainConstants.kVerificationBaseURL + "Password"
    static let kVSchool: String = KeychainConstants.kVerificationBaseURL + "School"
    static let kVHours: String = KeychainConstants.kVerificationBaseURL + "Hours"
    
    
}