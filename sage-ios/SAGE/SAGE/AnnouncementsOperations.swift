//
//  AnnouncementsOperations.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import AFNetworking

class AnnouncementsOperations {
    
    static func loadAnnouncements(filter filter: [String: String]? = nil, completion: (([Announcement]) -> Void), failure:((String) -> Void)) {
        var params = [
            NetworkingConstants.kSortAttr: CheckinConstants.kTimeCreated,
            NetworkingConstants.kSortOrder: NetworkingConstants.kDescending
        ]
        if !(LoginOperations.getUser()!.role == .Admin || LoginOperations.getUser()!.role == .President) {
            if filter == nil {
                let schoolID = LoginOperations.getUser()!.school!.id
                params[AnnouncementConstants.kDefault] = String(schoolID)
            }
        }
        if let filter = filter as [String: String]! {
            for (key, value) in filter {
                params[key] = value
            }
        }

        BaseOperation.manager().GET(StringConstants.kEndpointAnnouncements, parameters: params, success: { (operation, data) -> Void in
            let announcementsJSON = data["announcements"] as! [[String: AnyObject]]
            var announcements = [Announcement]()
            for item in announcementsJSON {
                let singleAnnouncement = Announcement(properties: item)
                announcements.append(singleAnnouncement)
            }
            completion(announcements)
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }

    static func deleteAnnouncement(announcement: Announcement, completion: (() -> Void)?, failure: (String) -> Void) {
        BaseOperation.manager().DELETE(StringConstants.kEndpointDeleteAnnouncement(announcement.id!), parameters: nil, success: { (operation, data) -> Void in
            completion?()
            }) { (operation, error) -> Void in
                failure(BaseOperation.getErrorMessage(error))
        }
    }

    
}