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
    
    static func loadMentors(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        var params: [String: AnyObject] = [String: AnyObject]()
        params[UserConstants.kAuthToken] = (KeychainWrapper.objectForKey(KeychainConstants.kAuthToken) as? String)
        manager.GET(StringConstants.kEndpointMentors, parameters: params, success: { (operation, data) -> Void in
            // handle the data and run success on an nsmutablearray
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
        
    }
    
    static func loadCheckinRequests(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()

    }
    
}
