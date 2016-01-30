//
//  CheckinOperations.swift
//  SAGE
//
//  Created by Andrew on 11/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import AFNetworking

class CheckinOperations {
    
    class func createCheckin(checkin: Checkin, success: (Checkin) -> Void, failure: (NSString) -> Void) {
        let checkinDict = NSMutableDictionary()
        checkinDict[CheckinConstants.kStartTime] = checkin.stringTimeFromStartDate()
        checkinDict[CheckinConstants.kEndTime] = checkin.stringTimeFromEndDate()
        checkinDict[CheckinConstants.kUserId] = checkin.user!.id
        checkinDict[CheckinConstants.kSchoolId] = checkin.school!.id
        checkinDict[CheckinConstants.kComment] = checkin.comment
        let params = NSDictionary(dictionary: ["check_in": checkinDict])
        
        BaseOperation.manager().POST(StringConstants.kEndpointCheckin, parameters: params, success: { (operation, data) -> Void in
            success(checkin)
        }, failure: { (operation, error) -> Void in
            failure(BaseOperation.getErrorMessage(error))
        })
    }
}
