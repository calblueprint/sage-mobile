//
//  PushNotificationOperations.swift
//  SAGE
//
//  Created by Erica Yin on 4/5/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class PushNotificationOperations {

    static func registerForNotifications(deviceID: String, completion: () -> Void, failure: (String) -> Void) {
        if let user = SAGEState.currentUser() {
            let params = [
                NetworkingConstants.kDeviceType: 1,
                NetworkingConstants.kDeviceID: deviceID
            ]

            BaseOperation.manager().POST(StringConstants.kEndpointRegisterForNotifications(user.id), parameters: params, success: { (operation, data) -> Void in
                completion()
                }) { (operation, error) -> Void in
                    failure(BaseOperation.getErrorMessage(error))
            }
        } else {
            return
        }

    }
}
