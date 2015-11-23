//
//  AdminOperations.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/11/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import AFNetworking

class AdminOperations {
    
    static func loadMentors(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        
    }
    
    static func loadCheckinRequests(completion: ((NSMutableArray) -> Void), failure: (String) -> Void){
        
    }
    
    static func createAnnouncement(announcement: Announcement, completion: (Announcement) -> Void, failure: (String) -> Void) {
        let manager = BaseOperation.manager()
        let announcementDict = announcement.toDictionary()
        manager.POST(StringConstants.kEndpointAnnouncements, parameters: announcementDict, success: { (operation, data) -> Void in
            completion(announcement)
            }) { (operation, error) -> Void in
                failure(error.localizedDescription)
        }
    }
}
