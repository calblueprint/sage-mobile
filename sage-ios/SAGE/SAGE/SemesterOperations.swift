//
//  SemesterOperations.swift
//  SAGE
//
//  Created by Andrew Millman on 1/25/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class SemesterOperations {
    
    static func startSemester(semester: Semester, completion: (Semester) -> Void, failure: (String) -> Void) {
        let params = [
            SemesterConstants.kStartDate: semester.dateStringFromStartDate(),
            SemesterConstants.kTerm: semester.term.rawValue
        ]
        
        BaseOperation.manager().POST(StringConstants.kEndpointStartSemester, parameters: params, success: { (operation, data) -> Void in
            let semesterDict = (data as! [String: AnyObject])["semester"] as! [String: AnyObject]
            let createdSemester = Semester(propertyDictionary: semesterDict)
            completion(createdSemester)
            }) { (operation, error) -> Void in
                failure("Could not start semester.")
        }
    }
    
    static func endSemester(completion: () -> Void, failure: (String) -> Void) {
        // TODO: Get semester from keychain
        let semester = Semester()
        BaseOperation.manager().POST(StringConstants.kEndpointEndSemester(semester.id), parameters: nil, success: { (operation, data) -> Void in
            completion()
            }) { (operation, error) -> Void in
                failure("Could not end semester.")
        }
    }
    
    static func joinSemester(completion: (() -> Void)?, failure: (String) -> Void) {
        BaseOperation.manager().POST(StringConstants.kEndpointJoinSemester, parameters: nil, success: { (operation, data) -> Void in
            completion?()
            }) { (operation, error) -> Void in
                failure("Could not join semester.")
        }
    }
}
