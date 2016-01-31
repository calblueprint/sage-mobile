//
//  SemesterSummary.swift
//  SAGE
//
//  Created by Erica Yin on 1/29/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class SemesterSummary: NSObject, NSCoding {
    
    enum Status: Int {
        case Active = 1
        case Inactive = 0
    }
    
    var id: Int = -1
    var totalMinutes: Int = 0
    var completed: Bool = false
    var status: Status = .Active
    var semesterID: Int = -1
    var hoursRequired: Int = 0
    
    init(id: Int = -1, totalMinutes: Int = 0, completed: Bool = false, status: Status = .Active, semesterID: Int = -1, hoursRequired: Int = 0) {
        self.id = id
        self.totalMinutes = totalMinutes
        self.completed = completed
        self.status = status
        self.semesterID = semesterID
        self.hoursRequired = hoursRequired
        super.init()
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        // set default values
        self.id = -1
        self.totalMinutes = 0
        self.completed = false
        self.status = Status.Active
        self.hoursRequired = 0
        
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case SemesterSummaryConstants.kStatus:
                if let val = value as? Int {
                    switch val {
                    case 0: self.status = Status.Inactive
                    case 1: self.status = Status.Active
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
            case SemesterSummaryConstants.kTotalMinutes:
                if let val = value as? Int {
                    self.totalMinutes = val
                }
            case SemesterSummaryConstants.kHoursRequired:
                if let val = value as? Int {
                    self.hoursRequired = val
                }
            default: break
            }
        }
        super.init()
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        if self.id != -1 {
            propertyDict[SemesterSummaryConstants.kId] = id
        }
        if Status.Active != self.status {
            switch self.status {
            case .Inactive: propertyDict[SemesterSummaryConstants.kStatus] = 0
            default: propertyDict[SemesterSummaryConstants.kStatus] = 1
            }
        }
        if self.totalMinutes != 0 {
            propertyDict[SemesterSummaryConstants.kTotalMinutes] = self.totalMinutes
        }
        if self.hoursRequired != 0 {
            propertyDict[SemesterSummaryConstants.kHoursRequired] = self.hoursRequired
        }
        if self.semesterID != -1 {
            propertyDict[SemesterSummaryConstants.kSemesterID] = self.semesterID
        }
        propertyDict[SemesterSummaryConstants.kCompleted] = self.completed
        return propertyDict
    }
    
    func statusToString(status: Status) -> String {
        switch status {
        case .Inactive:
            return "Inactive"
        default:
            return "Active"
        }
    }
    
    static func statusFromInt(number: Int) -> Status {
        if number == 0 {
            return Status.Inactive
        }
        return Status.Active
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey(SemesterSummaryConstants.kId)
        self.completed = aDecoder.decodeBoolForKey(SemesterSummaryConstants.kCompleted)
        self.status = SemesterSummary.statusFromInt(aDecoder.decodeIntegerForKey(SemesterSummaryConstants.kStatus))
        self.totalMinutes = aDecoder.decodeIntegerForKey(SemesterSummaryConstants.kTotalMinutes)
        self.hoursRequired = aDecoder.decodeIntegerForKey(SemesterSummaryConstants.kHoursRequired)
        self.semesterID = aDecoder.decodeIntegerForKey(SemesterSummaryConstants.kSemesterID)
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.id, forKey: SemesterSummaryConstants.kId)
        aCoder.encodeBool(self.completed, forKey: SemesterSummaryConstants.kCompleted)
        aCoder.encodeInteger(self.status.rawValue, forKey: SemesterSummaryConstants.kStatus)
        aCoder.encodeInteger(self.totalMinutes, forKey: SemesterSummaryConstants.kTotalMinutes)
        aCoder.encodeInteger(self.hoursRequired, forKey: SemesterSummaryConstants.kHoursRequired)
        aCoder.encodeInteger(self.semesterID, forKey: SemesterSummaryConstants.kSemesterID)
    }
}
