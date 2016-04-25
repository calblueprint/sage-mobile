//
//  String.swift
//  SAGE
//
//  Created by Andrew Millman on 4/25/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

extension String {

    func convertToDictionary() -> [String:AnyObject]? {
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch {
                return nil
            }
        }
        return nil
    }
}
