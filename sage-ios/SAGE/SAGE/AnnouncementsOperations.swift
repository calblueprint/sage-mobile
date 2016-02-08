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
    
    static func loadAnnouncements(completion: (([Announcement]) -> Void), failure:((String) -> Void)) {
        var params: [String: String]
        if LoginOperations.getUser()!.role == .Admin || LoginOperations.getUser()!.role == .President {
            params = [
                NetworkingConstants.kSortAttr: CheckinConstants.kTimeCreated,
                NetworkingConstants.kSortOrder: NetworkingConstants.kDescending
            ]
        } else {
            let schoolID = LoginOperations.getUser()!.school!.id
            params = [
                NetworkingConstants.kSortAttr: CheckinConstants.kTimeCreated,
                NetworkingConstants.kSortOrder: NetworkingConstants.kDescending,
                AnnouncementConstants.kDefault: String(schoolID)
            ]
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
    
}