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
        
        self.checkinView.startButton.addTarget(self, action: "beginSession:", forControlEvents: .TouchUpInside)
        self.checkinView.endButton.addTarget(self, action: "endSession:", forControlEvents: .TouchUpInside)

        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
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
    @objc private func beginSession(sender: UIButton!) {
        // save start time locally and start timer
        self.presentSessionMode(UIConstants.normalAnimationTime)
    }
    
    @objc private func endSession(sender: UIButton!) {
        // send request to make check in and present to default
        // when finished. if failure, store locally and 
        // try again until success
        self.presentDefaultMode(UIConstants.normalAnimationTime)
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
}

//
// MARK: - CLLocationManagerDelegate
//
extension CheckinViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {

        case .AuthorizedAlways, .AuthorizedWhenInUse:
            self.startGettingCurrentLocation()
            break
        case .Restricted, .Denied:
            // Manually ask the user to authorize
            break
        case .NotDetermined:
            self.locationManager.requestAlwaysAuthorization()
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