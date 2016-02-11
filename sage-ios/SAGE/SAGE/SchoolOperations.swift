//
//  SchoolOperations.swift
//  SAGE
//
//  Created by Erica Yin on 11/18/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import AFNetworking

class SchoolOperations {

    static func loadSchools(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        let operationManager = BaseOperation.manager()
        operationManager.GET(StringConstants.kEndpointSchool, parameters: nil, success: { (operation, data) -> Void in
            
            let schoolDict = data["schools"] as! NSMutableArray
            completion(schoolDict)
            }, failure: { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        })
    }
    
    static func deleteSchool(school: School, completion: (() -> Void)?, failure: (String) -> Void) {
        BaseOperation.manager().DELETE(StringConstants.kEndpointDeleteSchool(school.id), parameters: nil, success: { (operation, data) -> Void in
            completion?()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }

}
