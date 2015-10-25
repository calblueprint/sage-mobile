//
//  BaseOperation.swift
//  SAGE
//
//  Created by Andrew on 10/1/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import AFNetworking

class BaseOperation {
    
    class func manager() -> AFHTTPRequestOperationManager {
        let baseURL = NSURL(string: StringConstants.kBaseURL)
        return AFHTTPRequestOperationManager.init(baseURL: baseURL)
    }
}
