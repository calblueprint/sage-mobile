//
//  CheckinViewController.swift
//  SAGE
//
//  Created by Andrew on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

import FontAwesomeKit
import SwiftKeychainWrapper

class CheckinViewController: UIViewController {

    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var school = School()
    let distanceTolerance: CLLocationDistance = 2000 // in Meters
    
    let checkinView = CheckinView()
    let defaultTitleLabel = UILabel()
    let sessionTitleLabel = UILabel()
    
    var startTime: NSTimeInterval = 0.0
    var inSession: Bool = false
    var requiredTime: NSTimeInterval = 0.0

    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.checkinView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.school = KeychainWrapper.objectForKey(KeychainConstants.kSchool) as! School
        self.requiredTime = 3600 * 1 //LoginOperations.getUser()?.requiredHours()

        self.setupDefaultTitleLabel()
        self.setupSessionTitleLabel()
        self.setupBarButtonItems()
        
        self.checkinView.startButton.addTarget(self, action: "userPressedBeginSession", forControlEvents: .TouchUpInside)
        self.checkinView.endButton.addTarget(self, action: "userPressedEndSession", forControlEvents: .TouchUpInside)

        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.startGettingCurrentLocation()
        let marker = GMSMarker(position: self.school.location!.coordinate)
        marker.map = self.checkinView.mapView
    }
    
    override func viewWillAppear(animated: Bool) {
        // Change mode on loading view depending on whether user is
        // mid-check in or not
        if let storedStartTime = KeychainWrapper.stringForKey(KeychainConstants.kSessionStartTime) {
            self.presentSessionMode(0)
            self.inSession = true
            self.startTime = NSTimeInterval(storedStartTime)!
            self.updateSessionTime()
        } else {
            self.presentDefaultMode(0)
            self.inSession = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    //
    // MARK: - Button event handling
    //
    @objc private func userPressedBeginSession() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedWhenInUse, .AuthorizedAlways:
                // Verify location
                if self.currentLocationIsBySchool() {
                    let alertController = UIAlertController(
                        title: "Start mentoring session?",
                        message: nil,
                        preferredStyle: .ActionSheet)
                    alertController.addAction(UIAlertAction(title: "Start Session", style: .Default, handler: { (action: UIAlertAction) -> Void in
                        //save start time locally and start timer
                        self.presentSessionMode(UIConstants.normalAnimationTime)
                        self.inSession = true
                        self.startTime = NSDate.timeIntervalSinceReferenceDate()
                        self.updateSessionTime()
                        KeychainWrapper.setString(String(format: "%f", self.startTime), forKey: KeychainConstants.kSessionStartTime)
                    }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(
                        title: "Location too far",
                        message: "You are too far from \(school.name!). Please move closer to start mentoring.",
                        preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                break
            case .Denied, .Restricted, .NotDetermined:
                self.presentNeedsLocationAlert()
                break
            }
        }
    }
    
    @objc private func userPressedEndSession() {
        //Verify location
        if self.currentLocationIsBySchool() {
            let alertController = UIAlertController(
                title: "Finish mentoring session?",
                message: nil,
                preferredStyle: .ActionSheet)
            alertController.addAction(UIAlertAction(title: "Finish Session", style: .Default, handler: { (action: UIAlertAction) -> Void in
                self.presentRequestHoursView()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel Session", style: .Destructive, handler: { (action: UIAlertAction) -> Void in
                let confirmAlert = UIAlertController(
                    title: "Are you sure? Your session will be erased.",
                    message: nil,
                    preferredStyle: .ActionSheet)
                confirmAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    // send request to make check in and present to default
                    // when finished. if failure, store locally and
                    // try again until success
                    self.presentDefaultMode(UIConstants.normalAnimationTime)
                    self.inSession = false
                    KeychainWrapper.removeObjectForKey(KeychainConstants.kSessionStartTime)
                    //make a request
                }))
                confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                self.presentViewController(confirmAlert, animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(
                title: "Location too far",
                message: "You are too far from \(school.name!). Please move closer to finish mentoring.",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //
    // MARK: - Private methods
    //
    @objc private func updateSessionTime() {
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let timePassed = currentTime - startTime
        // get the user's min hours and pass that into percentage
        self.checkinView.updateTimerWithTime(timePassed, percentage: CGFloat(timePassed/self.requiredTime))
        if (self.inSession) {
            self.performSelector("updateSessionTime", withObject: nil, afterDelay: 1)
        }
    }
    
    @objc private func presentRequestHoursView() {
        let requestHoursController = RequestHoursViewController()
        if self.inSession {
            requestHoursController.inSession = true
            requestHoursController.startTime = self.startTime
        }
        let navController = UINavigationController(rootViewController: requestHoursController)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    private func setupDefaultTitleLabel() {
        self.defaultTitleLabel.text = "Check In"
        self.defaultTitleLabel.font = UIFont.getSemiboldFont(17.0)
        self.defaultTitleLabel.textAlignment = .Center
        self.defaultTitleLabel.textColor = UIColor.whiteColor()
        self.defaultTitleLabel.alpha = 0
        
        self.navigationController?.navigationBar.addSubview(self.defaultTitleLabel)
        self.defaultTitleLabel.sizeToFit()
        self.defaultTitleLabel.frame = CGRectIntegral(self.defaultTitleLabel.frame) // Done to prevent fuzzy text
        self.defaultTitleLabel.centerInSuperview()
    }
    
    private func setupSessionTitleLabel() {
        self.sessionTitleLabel.text = "Currently Mentoring"
        self.sessionTitleLabel.font = UIFont.getSemiboldFont(17.0)
        self.sessionTitleLabel.textAlignment = .Center
        self.sessionTitleLabel.textColor = UIColor.blackColor()
        self.sessionTitleLabel.alpha = 0
        
        self.navigationController?.navigationBar.addSubview(self.sessionTitleLabel)
        self.sessionTitleLabel.sizeToFit()
        self.sessionTitleLabel.frame = CGRectIntegral(self.sessionTitleLabel.frame) // Done to prevent fuzzy text
        self.sessionTitleLabel.centerInSuperview()
    }
    
    private func setupBarButtonItems() {
        let increase: CGFloat = 2.0
        let requestIcon = FAKMaterialIcons.plusIconWithSize(UIConstants.barbuttonIconSize + increase)
        let requestImage = requestIcon.imageWithSize(CGSizeMake(
            UIConstants.barbuttonIconSize + increase,
            UIConstants.barbuttonIconSize + increase))
        let requestHoursItem = UIBarButtonItem(image: requestImage!, style: .Plain, target: self, action: "presentRequestHoursView")
        self.navigationItem.rightBarButtonItem = requestHoursItem
    }
    
    private func startGettingCurrentLocation() {
        self.locationManager.startUpdatingLocation()
        self.checkinView.mapView.myLocationEnabled = true
        self.checkinView.mapView.settings.myLocationButton = true
    }
    
    private func currentLocationIsBySchool() -> Bool {
        let distance: CLLocationDistance = self.school.location!.distanceFromLocation(self.currentLocation)
        return  distance < self.distanceTolerance
    }
    
    private func presentDefaultMode(duration: NSTimeInterval) {
        self.checkinView.presentDefaultMode(duration)
        self.navigationItem.rightBarButtonItem?.enabled = true
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: duration != 0)
        UIView.animateWithDuration(duration) { () -> Void in
            self.defaultTitleLabel.alpha = 1
            self.sessionTitleLabel.alpha = 0
            self.navigationController?.navigationBar.barTintColor = UIColor.mainColor
        }
    }
    
    private func presentSessionMode(duration: NSTimeInterval) {
        self.checkinView.presentSessionMode(duration)
        self.navigationItem.rightBarButtonItem?.enabled = false
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: duration != 0)
        UIView.animateWithDuration(duration) { () -> Void in
            self.defaultTitleLabel.alpha = 0
            self.sessionTitleLabel.alpha = 1
            self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        }
    }
    
    private func presentNeedsLocationAlert() {
        let alertController = UIAlertController(
            title: "Please turn on location services.",
            message: "In order to turn on location services, go to Settings > SAGE > Location and allow 'While Using the App'",
            preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

//
// MARK: - CLLocationManagerDelegate
//
extension CheckinViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {

        case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.startGettingCurrentLocation()
            break
        case .Restricted, .Denied:
            self.presentNeedsLocationAlert()
            break
        case .NotDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            break
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            self.currentLocation = location
            self.checkinView.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            self.locationManager.stopUpdatingLocation()
        }
    }
}