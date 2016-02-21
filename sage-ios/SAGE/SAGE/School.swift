//
//  School.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import CoreLocation

class School: NSObject, NSCoding {
    var id: Int
    var name: String?
    var location: CLLocation? = CLLocation(latitude: 0, longitude: 0)
    var students: [User]?
    var director: User?
    var address: String?
    var studentCount: Int = 0
    var radius: CLLocationDistance = -1
    
    init(id: Int = -1, name: String? = nil, location: CLLocation? = nil, students: [User]? = nil, director: User? = nil, address: String? = nil, studentCount: Int = 0, radius: CLLocationDistance = -1) {
        self.id = id
        self.name = name
        self.location = location
        self.students = students
        self.director = director
        self.address = address
        self.studentCount = studentCount
        self.radius = radius
        super.init()
    }
    
    init(propertyDictionary: [String: AnyObject]) {
        self.id = -1
        for (propertyName, value) in propertyDictionary {
            switch propertyName {
            case SchoolConstants.kId:
                self.id = value as! Int
                break
            case SchoolConstants.kName:
                self.name = value as? String
                break
            case SchoolConstants.kStudents:
                self.students = []
                let studentsDictionaryArray = value as? [[String: AnyObject]]
                for studentDictionary in studentsDictionaryArray! {
                    let student: User = User(propertyDictionary: studentDictionary)
                    self.students!.append(student)
                }
                break
            case SchoolConstants.kStudentCount:
                self.studentCount = value as! Int
            case SchoolConstants.kLat:
                let latitude = Double(value as! String)
                self.location = CLLocation(latitude: latitude!, longitude: self.location!.coordinate.longitude)
                break
            case SchoolConstants.kLong:
                let long = Double(value as! String)
                self.location = CLLocation(latitude: self.location!.coordinate.latitude, longitude: long!)
                break
            case SchoolConstants.kDirector:
                if let dict = value as? [String: AnyObject] {
                    let directorDictionary = dict
                    self.director = User(propertyDictionary: directorDictionary)
                }
                break
            case SchoolConstants.kAddress:
                self.address = value as? String
            case SchoolConstants.kRadius:
                self.radius = value as! CLLocationDistance
            default: break
            }
        }
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey(SchoolConstants.kId)
        self.name = aDecoder.decodeObjectForKey(SchoolConstants.kName) as? String
        self.location = aDecoder.decodeObjectForKey(SchoolConstants.kLocation) as? CLLocation
        self.address = aDecoder.decodeObjectForKey(SchoolConstants.kAddress) as? String
        let possibleRadius = aDecoder.decodeObjectForKey(SchoolConstants.kRadius) as? CLLocationDistance
        if let radius = possibleRadius {
            self.radius = radius
        }
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.id, forKey: SchoolConstants.kId)
        aCoder.encodeObject(self.name, forKey: SchoolConstants.kName)
        aCoder.encodeObject(self.location, forKey: SchoolConstants.kLocation)
        aCoder.encodeObject(self.address, forKey: SchoolConstants.kAddress)
        aCoder.encodeObject(self.radius, forKey: SchoolConstants.kRadius)
    }
    
    func toDictionary() -> [String: AnyObject]{
        var propertyDict: [String: AnyObject] = [String: AnyObject]()
        if -1 != self.id {
            propertyDict[SchoolConstants.kId] = self.id
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
        if let address = self.address {
            propertyDict[SchoolConstants.kAddress] = address
        }
        if self.radius != -1 {
            propertyDict[SchoolConstants.kRadius] = radius
        }
        return propertyDict
    }
    
    func isBefore(otherSchool: School) -> Bool {
        return self.name < otherSchool.name
    }

    func getDefaultRadius() -> CLLocationDistance {
        return 200
    }
}

extension School: NSCopying {
    func copyWithZone(zone: NSZone) -> AnyObject {
        var copiedArray: [User]? = nil
        if let students = self.students {
            copiedArray = [User]()
            for student in students {
                copiedArray?.append((student.copy() as? User)!)
            }
        }
        return School(id: self.id, name: self.name?.copy() as? String, location: self.location?.copy() as? CLLocation, students: copiedArray, director: self.director?.copy() as? User, address: self.address, studentCount: self.studentCount, radius: self.radius)
    }
}
