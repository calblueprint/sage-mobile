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
    
    static func loadAnnouncements(page page: Int? = nil, filter: [String: AnyObject]? = nil, completion: (([Announcement]) -> Void), failure:((String) -> Void)) {
        var params: [String: AnyObject] = [
            NetworkingConstants.kSortAttr: CheckinConstants.kTimeCreated,
            NetworkingConstants.kSortOrder: NetworkingConstants.kDescending
        ]
        
        if let page = page {
            params[NetworkingConstants.kPage] = page
        }
        
        if !(SAGEState.currentUser()!.role == .Admin || SAGEState.currentUser()!.role == .President) {
            if filter == nil {
                let schoolID = SAGEState.currentUser()!.school!.id
                params[AnnouncementConstants.kDefault] = String(schoolID)
            }
        }
        params.appendDictionary(filter)
        
        
        BaseOperation.manager().GET(StringConstants.kEndpointAnnouncements, parameters: params, success: { (operation, data) -> Void in
            let announcementsJSON = data["announcements"] as! [[String: AnyObject]]
            var announcements = [Announcement]()
            for item in announcementsJSON {
                let singleAnnouncement = Announcement(propertyDictionary: item)
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
