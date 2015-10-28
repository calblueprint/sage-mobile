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
    static let JSONdateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    static let kEndpointBaseURL = "http://sage-rails.herokuapp.com/api/v1"
    static let kEndpointCreateUser = kEndpointBaseURL + "/users"
    static let kEndpointLogin = kEndpointBaseURL + "/users/sign_in"
    static let kEndpointLogout = kEndpointBaseURL + "/users/sign_out"
    static let kEndpointSchool = kEndpointBaseURL + "/schools"
}