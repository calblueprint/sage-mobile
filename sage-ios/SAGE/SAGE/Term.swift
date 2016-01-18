//
//  Term.swift
//  SAGE
//
//  Created by Andrew Millman on 1/18/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

enum Term: Int {
    case Spring = 0
    case Fall = 1
}

func termFromInt(number: Int) -> Term {
    if number == 0 {
        return Term.Spring
    }
    return Term.Fall
}

func stringFromTerm(term: Term) -> String {
    if term == .Spring {
        return "Spring"
    } else {
        return "Fall"
    }
}