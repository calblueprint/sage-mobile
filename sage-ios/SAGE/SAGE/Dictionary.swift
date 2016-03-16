//
//  Dictionary.swift
//  SAGE
//
//  Created by Andrew Millman on 3/8/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

extension Dictionary {

    mutating func appendDictionary(dictionary: Dictionary?) {
        if let dictionary = dictionary as Dictionary! {
            for (key, value) in dictionary {
                self[key] = value
            }
        }
    }
}