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

    override func loadView() {
        self.view = self.checkinView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Check in"

        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.startGettingCurrentLocation()
    }

    private func startGettingCurrentLocation() {
        self.locationManager.startUpdatingLocation()
        self.checkinView.mapView.myLocationEnabled = true
        self.checkinView.mapView.settings.myLocationButton = true
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