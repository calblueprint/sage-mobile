//
//  CheckinViewController.swift
//  SAGE
//
//  Created by Andrew on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class CheckinViewController: UIViewController {

    let locationManager = CLLocationManager()
    let checkinView = CheckinView()
    let defaultTitleLabel = UILabel()
    let sessionTitleLabel = UILabel()
    var startTime: NSTimeInterval = 0.0
    var inSession: Bool = false

    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.checkinView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaultTitleLabel()
        self.setupSessionTitleLabel()
        
        self.checkinView.startButton.addTarget(self, action: "userPressedBeginSession:", forControlEvents: .TouchUpInside)
        self.checkinView.endButton.addTarget(self, action: "userPressedEndSession:", forControlEvents: .TouchUpInside)

        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        // May wanna put in viewDidAppear() if we want to get the user's location every time the mapView appears
        self.startGettingCurrentLocation()
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
    @objc private func userPressedBeginSession(sender: UIButton!) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedWhenInUse, .AuthorizedAlways:
                //verify user's location first
                // if verified: then do this
                // if not: show a too far alert
                if true {
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
                    alertController.addAction(UIAlertAction(title: "Request Hours", style: .Default, handler: { (action: UIAlertAction) -> Void in
                        self.presentRequestHoursView()
                    }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(
                        title: "Location too far",
                        message: "You are too far from your school. Please move closer to your school to check in.",
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
    
    @objc private func userPressedEndSession(sender: UIButton!) {
        //Verify location
        if true {
            let alertController = UIAlertController(
                title: "Finish mentoring session?",
                message: nil,
                preferredStyle: .ActionSheet)
            alertController.addAction(UIAlertAction(title: "Finish Session", style: .Default, handler: { (action: UIAlertAction) -> Void in
                self.presentRequestHoursView()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel Session", style: .Destructive, handler: { (action: UIAlertAction) -> Void in
                // send request to make check in and present to default
                // when finished. if failure, store locally and
                // try again until success
                self.presentDefaultMode(UIConstants.normalAnimationTime)
                self.inSession = false
                KeychainWrapper.removeObjectForKey(KeychainConstants.kSessionStartTime)
                //make a request
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
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
        self.checkinView.updateTimerWithTime(timePassed, percentage: CGFloat(timePassed/3600))
        if (self.inSession) {
            self.performSelector("updateSessionTime", withObject: nil, afterDelay: 1)
        }
    }
    
    private func presentRequestHoursView() {
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
        self.defaultTitleLabel.font = UIFont.boldSystemFontOfSize(17.0)
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
        self.sessionTitleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        self.sessionTitleLabel.textAlignment = .Center
        self.sessionTitleLabel.textColor = UIColor.blackColor()
        self.sessionTitleLabel.alpha = 0
        
        self.navigationController?.navigationBar.addSubview(self.sessionTitleLabel)
        self.sessionTitleLabel.sizeToFit()
        self.sessionTitleLabel.frame = CGRectIntegral(self.sessionTitleLabel.frame) // Done to prevent fuzzy text
        self.sessionTitleLabel.centerInSuperview()
    }
    
    private func startGettingCurrentLocation() {
        self.locationManager.startUpdatingLocation()
        self.checkinView.mapView.myLocationEnabled = true
        self.checkinView.mapView.settings.myLocationButton = true
    }
    
    private func presentDefaultMode(duration: NSTimeInterval) {
        self.checkinView.presentDefaultMode(duration)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: duration != 0)
        UIView.animateWithDuration(duration) { () -> Void in
            self.defaultTitleLabel.alpha = 1
            self.sessionTitleLabel.alpha = 0
            self.navigationController?.navigationBar.barTintColor = UIColor.mainColor
        }
    }
    
    private func presentSessionMode(duration: NSTimeInterval) {
        self.checkinView.presentSessionMode(duration)
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
            self.checkinView.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            self.locationManager.stopUpdatingLocation()
        }
    }
}