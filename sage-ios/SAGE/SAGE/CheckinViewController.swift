//
//  CheckinViewController.swift
//  SAGE
//
//  Created by Andrew on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class CheckinViewController: UIViewController {

    let locationManager = CLLocationManager()
    let checkinView = CheckinView()

    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.checkinView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Check in"
        
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
        if true {
            self.presentDefaultMode(0)
        } else {
            self.presentSessionMode(0)
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
                        message: "Do you want to start your mentoring session?",
                        preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) -> Void in
                        //save start time locally and start timer
                        self.presentSessionMode(UIConstants.normalAnimationTime)
                    }))
                    alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
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
        let alertController = UIAlertController(
            title: "End mentoring session?",
            message: "Do you want to end your mentoring session?",
            preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) -> Void in
            // send request to make check in and present to default
            // when finished. if failure, store locally and
            // try again until success
            self.presentDefaultMode(UIConstants.normalAnimationTime)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //
    // MARK: - Private methods
    //
    private func startGettingCurrentLocation() {
        self.locationManager.startUpdatingLocation()
        self.checkinView.mapView.myLocationEnabled = true
        self.checkinView.mapView.settings.myLocationButton = true
    }
    
    private func presentDefaultMode(duration: NSTimeInterval) {
        self.checkinView.presentDefaultMode(duration)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: duration != 0)
        UIView.animateWithDuration(duration) { () -> Void in
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.navigationController?.navigationBar.barTintColor = UIColor.mainColor
        }
    }
    
    private func presentSessionMode(duration: NSTimeInterval) {
        self.checkinView.presentSessionMode(duration)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: duration != 0)
        UIView.animateWithDuration(duration) { () -> Void in
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
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