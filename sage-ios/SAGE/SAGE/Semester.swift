//
//  Semester.swift
//  SAGE
//
//  Created by Andrew Millman on 1/18/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

enum Term: Int {
    case Spring = 0
    case Fall = 1
}

class Semester: NSObject {
    
    var id: Int = -1
    var startDate: NSDate?
    var term: Term = .Spring
    
    //
    // MARK: - Initialization
    //
    init(id: Int = -1, startDate: NSDate? = nil, term: Term = .Spring) {
        self.id = id
        self.startDate = startDate
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
    func stringFromStartDate() -> NSString {
        let formatter = NSDateFormatter()
        formatter.dateFormat = StringConstants.displayDateFormat
        return formatter.stringFromDate(self.startDate!)
    }
    
    static func termFromInt(number: Int) -> Term {
        if number == 0 {
            return Term.Spring
        }
        return Term.Fall
    }
    
    static func stringFromTerm(term: Term) -> String {
        if term == .Spring {
            return "Spring"
        } else {
            return "Fall"
        }
    }
}

