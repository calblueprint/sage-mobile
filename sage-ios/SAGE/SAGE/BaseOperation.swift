//
//  BaseOperation.swift
//  SAGE
//
//  Created by Andrew on 10/1/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftKeychainWrapper

class BaseOperation {
    
    class func manager() -> AFHTTPRequestOperationManager {
        let baseURL = NSURL(string: StringConstants.kBaseURL)
        return AFHTTPRequestOperationManager.init(baseURL: baseURL)
    }
    
    // This should be added to every params with any request while logged in
    class func addAuthParams(params: NSMutableDictionary) {
        params[UserConstants.kEmail] = KeychainWrapper.objectForKey(KeychainConstants.kVEmail)
        params[UserConstants.kAuthToken] = KeychainWrapper.objectForKey(KeychainConstants.kAuthToken)
    }
}
