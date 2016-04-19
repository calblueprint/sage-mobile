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
    
    static func loadSemesters(completion: (([Semester]) -> Void), failure: (String) -> Void){
        let manager = BaseOperation.manager()

        let params: [String: AnyObject] = [
            NetworkingConstants.kSortAttr: SemesterConstants.kStartDate,
            NetworkingConstants.kSortOrder: NetworkingConstants.kDescending
        ]

        manager.GET(StringConstants.kEndpointSemesters, parameters: params, success: { (operation, data) -> Void in
            var semesters = [Semester]()
            let semesterArray = data["semesters"] as! [AnyObject]
            for semesterDict in semesterArray {
                let semester = Semester(propertyDictionary: semesterDict as! [String: AnyObject])
                semesters.append(semester)
            }
            completion(semesters)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
    static func getSemester(semesterID: String, completion: (Semester) -> Void, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let endpoint = StringConstants.kEndpointSemesters + "/" + semesterID
        
        manager.GET(endpoint, parameters: nil, success: { (operation, data) -> Void in
            var semester = Semester(propertyDictionary: data["semester"] as! [String: AnyObject])
            completion(semester)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }

    static func startSemester(semester: Semester, completion: (Semester) -> Void, failure: (String) -> Void) {
        let params = [
            SemesterConstants.kStartDate: semester.dateStringFromStartDate(),
            SemesterConstants.kTerm: semester.term.rawValue
        ]
        
        BaseOperation.manager().POST(StringConstants.kEndpointStartSemester, parameters: params, success: { (operation, data) -> Void in
            let semesterDict = (data as! [String: AnyObject])["semester"] as! [String: AnyObject]
            let createdSemester = Semester(propertyDictionary: semesterDict)
            KeychainWrapper.setObject(createdSemester, forKey: KeychainConstants.kCurrentSemester)
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.startSemesterKey, object: createdSemester)
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
            KeychainWrapper.removeObjectForKey(KeychainConstants.kSessionStartTime)
            KeychainWrapper.removeObjectForKey(KeychainConstants.kSemesterSummary)
            KeychainWrapper.removeObjectForKey(KeychainConstants.kCurrentSemester)
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.endSemesterKey, object: nil)
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
    
    static func exportSemester(semester: Semester, completion: (() -> Void)?, failure: (String) -> Void) {
        
        BaseOperation.manager().GET(StringConstants.kEndpointExportSemester(semester.id), parameters: nil, success: { (operation, data) -> Void in
            completion?()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
    
}
