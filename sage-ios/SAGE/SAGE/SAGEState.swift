//
//  SAGEState.swift
//  SAGE
//
//  Created by Andrew Millman on 12/7/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class SAGEState {
    
    //
    // MARK: - Public Methods
    //
    class func currentUser() -> User? {
        return self.objectForKey(KeychainConstants.kUser) as? User
    }
    
    class func setCurrentUser(user: User) {
        self.saveObject(user, key: KeychainConstants.kUser)
    }
    
    class func removeCurrentUser() {
        self.removeObjectForKey(KeychainConstants.kUser)
    }
    
    class func currentSchool() -> School? {
        return self.objectForKey(KeychainConstants.kSchool) as? School
    }
    
    class func setCurrentSchool(school: School) {
        self.saveObject(school, key: KeychainConstants.kSchool)
    }
    
    class func removeCurrentSchool() {
        self.removeObjectForKey(KeychainConstants.kSchool)
    }
    
    class func currentSemester() -> Semester? {
        return self.objectForKey(KeychainConstants.kCurrentSemester) as? Semester
    }
    
    class func setCurrentSemester(semester: Semester) {
        self.saveObject(semester, key: KeychainConstants.kCurrentSemester)
    }
    
    class func removeCurrentSemester() {
        self.removeObjectForKey(KeychainConstants.kCurrentSemester)
    }
    
    class func semesterSummary() -> SemesterSummary? {
        return self.objectForKey(KeychainConstants.kSemesterSummary) as? SemesterSummary
    }
    
    class func setSemesterSummary(semesterSummary: SemesterSummary) {
        self.saveObject(semesterSummary, key: KeychainConstants.kSemesterSummary)
    }
    
    class func removeSemesterSummary() {
        self.removeObjectForKey(KeychainConstants.kSemesterSummary)
    }
    
    class func authToken() -> String? {
        return self.objectForKey(KeychainConstants.kAuthToken) as? String
    }
    
    class func setAuthToken(authToken: String) {
        self.saveObject(authToken, key: KeychainConstants.kAuthToken)
    }
    
    class func removeAuthToken() {
        self.removeObjectForKey(KeychainConstants.kAuthToken)
    }
    
    class func sessionStartTime() -> Double {
        return self.doubleForKey(KeychainConstants.kSessionStartTime)
    }
    
    class func setSessionStartTime(sessionStartTime: Double) {
        self.saveDouble(sessionStartTime, key: KeychainConstants.kSessionStartTime)
    }
    
    class func removeSessionStartTime() {
        self.removeObjectForKey(KeychainConstants.kSessionStartTime)
    }
    
    class func checkinRequestCount() -> Int {
        return self.integerForKey(KeychainConstants.kCheckInRequests)
    }
    
    class func setCheckinRequestCount(requestCount: Int) {
        self.saveInteger(requestCount, key: KeychainConstants.kCheckInRequests)
    }
    
    class func removeCheckinRequestCount() {
        self.removeObjectForKey(KeychainConstants.kCheckInRequests)
    }
    
    class func signUpRequestCount() -> Int {
        return self.integerForKey(KeychainConstants.kSignUpRequests)
    }
    
    class func setSignUpRequestCount(requestCount: Int) {
        self.saveInteger(requestCount, key: KeychainConstants.kSignUpRequests)
    }
    
    class func removeSignUpRequestCount() {
        self.removeObjectForKey(KeychainConstants.kSignUpRequests)
    }
    
    class func setLocationNotification(preference: Bool) {
        // true = 2, false = 1, not set = 0
        if (preference) {
            UserNotifications.createLocationNotification(presentingViewController: RootController.sharedController())
        } else {
            UserNotifications.removeAllPendingNotifications()
        }
        self.saveInteger(preference ? 2 : 1, key: KeychainConstants.kLocationNotification)
    }
    
    class func locationNotificationPreferenceInt() -> Int {
        // true = 2, false = 1, not set = 0
        return self.integerForKey(KeychainConstants.kLocationNotification)
    }
    
    class func reset() {
        self.removeCurrentUser()
        self.removeCurrentSchool()
        self.removeCurrentSemester()
        self.removeSemesterSummary()
        self.removeAuthToken()
        self.removeSessionStartTime()
        self.removeCheckinRequestCount()
        self.removeSignUpRequestCount()
    }
    
    //
    // MARK: - Private Methods
    //
    private class func saveObject(object: AnyObject, key: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(object)
        userDefaults.setObject(encodedData, forKey: key)
        userDefaults.synchronize()
    }
    
    private class func objectForKey(key: String) -> AnyObject? {
        if let decodedObject  = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(decodedObject)
        }
        return nil
    }
    
    private class func saveInteger(value: Int, key: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(value, forKey: key)
        userDefaults.synchronize()
    }
    
    private class func integerForKey(key: String) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
    private class func saveDouble(value: Double, key: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setDouble(value, forKey: key)
        userDefaults.synchronize()
    }
    
    private class func doubleForKey(key: String) -> Double {
        return NSUserDefaults.standardUserDefaults().doubleForKey(key)
    }
    
    private class func removeObjectForKey(key: String) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
    }
}
