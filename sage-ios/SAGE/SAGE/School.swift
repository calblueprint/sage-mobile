//
//  School.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import CoreLocation

class School: NSObject {
    var id: Int?
    var name: String?
    var location: CLLocation? = CLLocation(latitude: 0, longitude: 0)
    var students: [User]?
    var director: User?
    
    init(id: Int? = nil, name: String? = nil, location: CLLocation? = nil, students: [User]? = nil, director: User? = nil) {
        super.init()
        self.id = id
        self.name = name
        self.location = location
        self.students = students
        self.director = director
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        super.init()
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case SchoolConstants.kId:
                self.id = value as? Int
            case SchoolConstants.kName:
                self.name = value as? String
            case SchoolConstants.kStudents:
                self.students = []
                let studentsDictionaryArray = value as? [[String: AnyObject]]
                for studentDictionary in studentsDictionaryArray! {
                    let student: User = User(propertyDictionary: studentDictionary)
                    self.students!.append(student)
                }
            case SchoolConstants.kLocation:
                let locationDictionary = value as! [String:Double]
                let latitude = locationDictionary[SchoolConstants.kLat]
                let longitude = locationDictionary[SchoolConstants.kLong]
                self.location = CLLocation(latitude: latitude!, longitude: longitude!)
            case SchoolConstants.kDirector:
                let directorDictionary = value as! [String: AnyObject]
                self.director = User(propertyDictionary: directorDictionary)
            default: break
            }
        }
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        if let id = self.id {
            propertyDict[SchoolConstants.kId] = id
        }
        if let name = self.name {
            propertyDict[SchoolConstants.kName] = name
        }
        if let location = self.location {
            let latLongDict = [SchoolConstants.kLat: location.coordinate.latitude, SchoolConstants.kLong: location.coordinate.longitude]
            propertyDict[SchoolConstants.kLocation] = latLongDict
        }
        if let students = self.students {
            var studentDict: [[String: AnyObject]] = [[String: AnyObject]]()
            for student in students{
                studentDict.append(student.toDictionary())
            }
            propertyDict[SchoolConstants.kStudents] = students
        }
        if let director = self.director {
            propertyDict[SchoolConstants.kDirector] = director.toDictionary()
        }
        return propertyDict
    }
}
