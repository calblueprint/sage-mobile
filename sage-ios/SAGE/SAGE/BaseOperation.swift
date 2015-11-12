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
        let operationManager = AFHTTPRequestOperationManager.init(baseURL: baseURL)
        if let _ = KeychainWrapper.objectForKey(KeychainConstants.kAuthToken) {
            BaseOperation.addAuthParams(operationManager)
        }
        return operationManager
    }
    
    // This should be added to every params with any request while logged in
    class func addAuthParams(manager: AFHTTPRequestOperationManager) {
        manager.requestSerializer.setValue(KeychainWrapper.objectForKey(KeychainConstants.kAuthToken) as? String, forHTTPHeaderField: "X-AUTH-TOKEN")
        manager.requestSerializer.setValue(KeychainWrapper.objectForKey(KeychainConstants.kVEmail) as? String, forHTTPHeaderField: "X-AUTH-EMAIL")
    }
}
