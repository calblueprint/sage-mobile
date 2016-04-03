//
//  AddSchoolController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddSchoolController: FormController {
    
    var director: User?
    var location: CLLocation?
    var address: String?
    var radius: CLLocationDistance? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let addSchoolView = AddSchoolView(frame: self.view.frame)
        self.view = addSchoolView
        self.title = "Add School"
        addSchoolView.location.button.addTarget(self, action: "locationButtonTapped", forControlEvents: .TouchUpInside)
        addSchoolView.director.button.addTarget(self, action: "directorButtonTapped", forControlEvents: .TouchUpInside)
        addSchoolView.radius.button.addTarget(self, action: "radiusButtonTapped", forControlEvents: .TouchUpInside)
    }
    
    func locationButtonTapped() {
        let vc = AddSchoolLocationTableViewController()
        vc.parentVC = self
        if let location = self.location {
            vc.configureWithLocation(location)
        }
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func directorButtonTapped() {
        let tableViewController = AddSchoolDirectorTableViewController()
        tableViewController.parentVC = self
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }

    func radiusButtonTapped() {
        if self.location == nil {
            self.showAlertControllerError("Please choose a location first.")
        } else {
            let viewController = AddSchoolRadiusViewController(center: self.location!.coordinate, radius: self.radius)
            viewController.parentVC = self
            if let topItem = self.navigationController?.navigationBar.topItem {
                topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func completeForm() {
        let addSchoolView = (self.view as! AddSchoolView)
        if self.location == nil {
            self.showAlertControllerError("Please choose a location.")
        } else if self.radius == nil {
            self.showAlertControllerError("Please choose a radius.")
        } else if addSchoolView.name.textField.text == nil || addSchoolView.name.textField.text == "" {
            self.showAlertControllerError("What's the school's name?")
        }
        else {
            self.finishButton?.startLoading()
            let school = School(name: addSchoolView.name.textField.text, location: self.location, director: self.director, address: self.address, radius: self.radius!)
            AdminOperations.createSchool(school, completion: { (createdSchool) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.addSchoolKey, object: createdSchool)
                }, failure: { (message) -> Void in
                    self.finishButton?.stopLoading()
                    self.showAlertControllerError(message)
            })
        }
    }
    
    func didSelectRadius(radius: CLLocationDistance) {
        self.radius = radius
        (self.view as! AddSchoolView).displayRadius(radius)
    }

    func didSelectDirector(director: User) {
        self.director = director
        (self.view as! AddSchoolView).displayChosenDirector(director)
    }
    
    func didSelectCoordinate(coordinate: CLLocationCoordinate2D) {
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func didSelectPlace(place: GMSPlace) {
        let coordinate = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.didSelectCoordinate(coordinate)
        self.address = place.formattedAddress
        (self.view as? AddSchoolView)?.displayChosenPlace(place)
    }
    
    func selectPlacemarkData(placemark: CLPlacemark, coordinate: CLLocationCoordinate2D) {
        let newAddress = placemark.makeAddressString()
        if newAddress != "" {
            self.address = newAddress
            (self.view as? AddSchoolView)?.displayAddressText(address)
        }
        self.didSelectCoordinate(coordinate)
    }

}
