//
//  SAGETests.swift
//  SAGETests
//
//  Created by Andrew Millman on 9/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import XCTest
@testable import SAGE



class ModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func modelInitializationTests() {
        let userDict = [UserConstants.kId: 2]
        let schoolDict = [SchoolConstants.kId: 3]
        let announcement = Announcement(propertyDictionary: [AnnouncementConstants.kId: 1, AnnouncementConstants.kSender: userDict, AnnouncementConstants.kTitle: "Title of the announcement", AnnouncementConstants.kSchool: schoolDict])
        XCTAssertEqual(announcement.id, 1);
        XCTAssertEqual(announcement.sender!.id!, 2);
        XCTAssertEqual(announcement.school!.id!, 3);
        XCTAssertEqual(announcement.title, "Title of the announcement");
    }
    
}
