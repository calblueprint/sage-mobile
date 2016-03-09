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

    static func loadSchools(completion: (([School]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()
        manager.GET(StringConstants.kEndpointGetSchools, parameters: nil, success: { (operation, data) -> Void in
            var schools = [School]()
            let schoolArray = data["schools"] as! [AnyObject]
            for schoolDict in schoolArray {
                let school = School(propertyDictionary: schoolDict as! [String: AnyObject])
                schools.append(school)
            }
            schools.sortInPlace({ (school1, school2) -> Bool in
                school1.isBefore(school2)
            })
            completion(schools)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }

    }
    
    static func deleteSchool(school: School, completion: (() -> Void)?, failure: (String) -> Void) {
        BaseOperation.manager().DELETE(StringConstants.kEndpointDeleteSchool(school.id), parameters: nil, success: { (operation, data) -> Void in
            completion?()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }

}
