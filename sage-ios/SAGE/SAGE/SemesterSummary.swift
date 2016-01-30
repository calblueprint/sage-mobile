//
//  SemesterSummary.swift
//  SAGE
//
//  Created by Erica Yin on 1/29/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class SemesterSummary: NSObject {
    
    enum Status: Int {
        case Default = 1
        case Inactive = 0
    }
    
    var id: Int = -1
    var totalTime: Int = 0
    var completed: Bool = false
    var status: Status = .Default
    var semesterID: Int = -1
    // var userID: Int?
    // var hoursRequired: Int?
    
    init(id: Int = -1, totalTime: Int = 0, completed: Bool = false, status: Status = .Default, semesterID: Int = -1) {
        self.id = id
        self.totalTime = totalTime
        self.completed = completed
        self.status = status
        self.semesterID = semesterID
        super.init()
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        // set default values
        self.id = -1
        self.totalTime = 0
        self.completed = false
        self.status = Status.Default
        
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case SemesterSummaryConstants.kStatus:
                if let val = value as? Int {
                    switch val {
                    case 0: self.status = Status.Inactive
                    case 1: self.status = Status.Default
                    default: break
                    }
                }
            case SemesterSummaryConstants.kCompleted:
                if let val = value as? Bool {
                    self.completed = val
                }
            case SemesterSummaryConstants.kId:
                if let val = value as? Int {
                    self.id = val
                }
            case SemesterSummaryConstants.kSemesterID:
                if let intValue = value as? Int {
                    self.semesterID = intValue
                }
            case UserConstants.kTotalTime:
                if let val = value as? Int {
                    self.totalTime = val // in minutes
                }
            default: break
            }
        }
        super.init()
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        if -1 != self.id {
            propertyDict[SemesterSummaryConstants.kId] = id
        }
        if Status.Default != self.status {
            switch self.status {
            case .Inactive: propertyDict[SemesterSummaryConstants.kStatus] = 0
            default: propertyDict[SemesterSummaryConstants.kStatus] = 1
            }
        }
        if -1 != self.totalTime {
            propertyDict[SemesterSummaryConstants.kTotalTime] = self.totalTime // in minutes
        }
        if -1 != self.semesterID {
            propertyDict[SemesterSummaryConstants.kSemesterID] = self.semesterID
        }
        propertyDict[SemesterSummaryConstants.kCompleted] = self.completed
        return propertyDict
    }
    
}
