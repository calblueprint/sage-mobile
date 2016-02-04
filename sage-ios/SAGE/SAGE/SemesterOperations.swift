//
//  SemesterOperations.swift
//  SAGE
//
//  Created by Andrew Millman on 1/25/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

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
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func endSemester(completion: () -> Void, failure: (String) -> Void) {
        let semester = KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) as! Semester

        let formatter = NSDateFormatter()
        formatter.dateFormat = StringConstants.displayDateFormat
        let finishString = formatter.stringFromDate(NSDate())

        let params = [
            SemesterConstants.kFinishDate: finishString
        ]

        BaseOperation.manager().POST(StringConstants.kEndpointEndSemester(semester.id), parameters: params, success: { (operation, data) -> Void in
            completion()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func joinSemester(completion: (() -> Void)?, failure: (String) -> Void) {
        BaseOperation.manager().POST(StringConstants.kEndpointJoinSemester, parameters: nil, success: { (operation, data) -> Void in
            let userJSON = data["session"]!!["user"] as! [String: AnyObject]
            let semesterSummaryJSON = userJSON["user_semester"]
            var semesterSummary: SemesterSummary? = nil
            if !(semesterSummaryJSON is NSNull) {
                semesterSummary = SemesterSummary(propertyDictionary: semesterSummaryJSON as! [String: AnyObject])
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.joinSemesterKey, object: semesterSummary)
            }
            KeychainWrapper.setObject(semesterSummary!, forKey: KeychainConstants.kSemesterSummary)
            completion?()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
}
