//
//  AnnouncementsOperations.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import AFNetworking

class AnnouncementsOperations {
    
    static func loadSchools(completion: ((NSMutableArray) -> Void)){
        
        let operationManager = BaseOperation.manager()
        
        operationManager.GET(StringConstants.kEndpointSchool, parameters: nil, success: { (operation, data) -> Void in
            
            let schoolDict = data["schools"] as! NSMutableArray
            completion(schoolDict)
            }, failure: nil)
    }
    
}