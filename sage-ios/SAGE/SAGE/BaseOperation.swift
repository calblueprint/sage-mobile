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
    
    static func loadSchools(completion: ((NSMutableArray) -> Void)){
        
        let operationManager = AFHTTPRequestOperationManager()
        operationManager.requestSerializer = AFJSONRequestSerializer()
        operationManager.responseSerializer = AFJSONResponseSerializer()
        
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        operationManager.GET(StringConstants.kEndpointSchool, parameters: nil, success: { (operation, data) -> Void in
            
            let schoolDict = data["schools"] as! NSMutableArray
            completion(schoolDict)
        }, failure: nil)
    }
}
