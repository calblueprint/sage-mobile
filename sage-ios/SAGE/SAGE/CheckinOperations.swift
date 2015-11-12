//
//  CheckinOperations.swift
//  SAGE
//
//  Created by Andrew on 11/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class CheckinOperations {
    
    class func createCheckin(params: [String: AnyObject?], success: (Checkin) -> Void, failure: (NSString) -> Void) {
        BaseOperation.manager().POST(StringConstants.kEndpointCheckin, parameters: nil, success: { (operation, data) -> Void in
            //parse json
        }, failure: { (operation, error) -> Void in
            //just pass error message
        })
    }
}
