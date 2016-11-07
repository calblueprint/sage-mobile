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
        if let _ = KeychainWrapper.defaultKeychainWrapper().objectForKey(KeychainConstants.kAuthToken) {
            BaseOperation.addAuthParams(operationManager)
        }
        return operationManager
    }
    
    // This should be added to every params with any request while logged in
    private class func addAuthParams(manager: AFHTTPRequestOperationManager) {
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue(KeychainWrapper.defaultKeychainWrapper().objectForKey(KeychainConstants.kAuthToken) as? String, forHTTPHeaderField: "X-AUTH-TOKEN")
        if let user = KeychainWrapper.defaultKeychainWrapper().objectForKey(KeychainConstants.kUser) as? User {
            if let email = user.email {
                 manager.requestSerializer.setValue(email, forHTTPHeaderField: "X-AUTH-EMAIL")
            }
        }
    }
    
    static func getErrorMessage(error: NSError) -> String {
        let errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
        if let response = errorResponse as? NSData {
            let errorDict = try? NSJSONSerialization.JSONObjectWithData(response, options: [])
            let errorMessage = errorDict?["error"]??["message"] as? String
            if let message = errorMessage {
                return message
            } else {
                return StringConstants.defaultErrorMessage
            }
        }
        return StringConstants.defaultErrorMessage
    }
}
