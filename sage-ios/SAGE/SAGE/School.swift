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
    var location: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var students: [User]?
    var director: User?
    
    init(id: Int, name: String, location: CLLocation, students: [User], director: User) {
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
            case SchoolConstants.kStudents:
                self.students = []
                let studentsDictionaryArray = propertyDictionary[propertyName] as? [[String: AnyObject]]
                for studentDictionary in studentsDictionaryArray! {
                    let student: User = User(propertyDictionary: studentDictionary)
                    self.students!.append(student)
                }
            case SchoolConstants.kLocation:
                let locationDictionary = propertyDictionary[propertyName] as! [String:Double]
                let latitude = locationDictionary["lat"]
                let longitude = locationDictionary["long"]
                self.location = CLLocation(latitude: latitude!, longitude: longitude!)
            case SchoolConstants.kDirector:
                let directorDictionary = propertyDictionary[propertyName] as! [String: AnyObject]
                self.director = User(propertyDictionary: directorDictionary)
            default:
                self.setValue(value, forKey: propertyName)
            }
        }
    }
    
    override init() {
        super.init()
    }
}
