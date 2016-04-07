//
//  NotificationOperations.swift
//  SAGE
//
//  Created by Erica Yin on 4/5/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class NotificationOperations {

    static func registerForNotifications(userID: Int, deviceID: String, deviceType: Int, completion: () -> Void, failure: (String) -> Void) {
        let params = [
            NetworkingConstants.kDeviceType: deviceType,
            NetworkingConstants.kDeviceID: deviceID
        ]

        BaseOperation.manager().POST(StringConstants.kEndpointRegisterForNotifications(userID), parameters: params, success: { (operation, data) -> Void in
            completion()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }
}