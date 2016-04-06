//
//  Semester.swift
//  SAGE
//
//  Created by Andrew Millman on 1/18/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

enum Term: Int {
    case Fall = 0
    case Spring = 1
}

class Semester: NSObject, NSCoding {
    
    var id: Int = -1
    var startDate: NSDate?
    var finishDate: NSDate?
    var term: Term = .Spring
    
    //
    // MARK: - Initialization
    //
    init(id: Int = -1, startDate: NSDate? = nil, finishDate: NSDate? = nil, term: Term = .Spring) {
        self.id = id
        self.startDate = startDate
        self.finishDate = finishDate
        self.term = term
        super.init()
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case SemesterConstants.kId:
                self.id = value as! Int
            case SemesterConstants.kStartDate:
                let formatter = NSDateFormatter()
                formatter.dateFormat = StringConstants.JSONdateFormat
                self.startDate = formatter.dateFromString(value as! String)
            case SemesterConstants.kFinishDate:
                let formatter = NSDateFormatter()
                if let val = value as? String {
                    formatter.dateFormat = StringConstants.JSONdateFormat
                    self.finishDate = formatter.dateFromString(value as! String)
                }
            case SemesterConstants.kTerm:
                self.term = Semester.termFromInt(value as! Int)
            default: break
            }
        }
        super.init()
    }
    
    //
    // MARK: - Public Methods
    //
    func displayText() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        return Semester.stringFromTerm(self.term) + " " + formatter.stringFromDate(self.startDate!)
    }

    func dateStringFromStartDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        return formatter.stringFromDate(self.startDate!)
    }
    
    func dateStringFromFinishDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        if self.finishDate == nil {
            return "Present"
        }
        return formatter.stringFromDate(self.finishDate!)
    }
    
    static func termFromInt(number: Int) -> Term {
        if number == 0 {
            return Term.Fall
        }
        return Term.Spring
    }
    
    static func stringFromTerm(term: Term) -> String {
        if term == .Spring {
            return "Spring"
        } else {
            return "Fall"
        }
    }
    
    //
    // MARK: - NSCoding
    //
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey(SemesterConstants.kId)
        self.startDate = aDecoder.decodeObjectForKey(SemesterConstants.kStartDate) as? NSDate
        self.finishDate = aDecoder.decodeObjectForKey(SemesterConstants.kFinishDate) as? NSDate
        self.term = Semester.termFromInt(aDecoder.decodeIntegerForKey(SemesterConstants.kTerm))
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.id, forKey: SemesterConstants.kId)
        aCoder.encodeObject(self.startDate, forKey: SemesterConstants.kStartDate)
        aCoder.encodeObject(self.finishDate, forKey: SemesterConstants.kFinishDate)
        aCoder.encodeInteger(self.term.rawValue, forKey: SemesterConstants.kTerm)
    }
}

