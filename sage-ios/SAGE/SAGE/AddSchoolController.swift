//
//  AddSchoolController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddSchoolController: UIViewController {
    
    var director: User?
    var location: CLLocation?
    var currentErrorMessage: ErrorView?

    override func viewDidLoad() {
        let addSchoolView = AddSchoolView(frame: self.view.frame)
        self.view = addSchoolView
        self.title = "Add School"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .Done, target: self, action: "completeForm")
        addSchoolView.location.button.addTarget(self, action: "locationButtonTapped", forControlEvents: .TouchUpInside)
        addSchoolView.director.button.addTarget(self, action: "directorButtonTapped", forControlEvents: .TouchUpInside)
    }
    
    func locationButtonTapped() {
        let tableViewController = AddSchoolLocationTableViewController()
        tableViewController.parentVC = self
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(tableViewController, animated: true)
    }
    
    func directorButtonTapped() {
        let tableViewController = AddSchoolDirectorTableViewController()
        tableViewController.parentVC = self
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(tableViewController, animated: true)
    }
    
    func completeForm() {
        let addSchoolView = (self.view as! AddSchoolView)
        if self.director == nil {
            self.showAlertControllerError("Please choose a director.")
        } else if self.location == nil {
            self.showAlertControllerError("Please choose a location.")
        } else if addSchoolView.name.textField.text == nil || addSchoolView.name.textField.text == "" {
            self.showAlertControllerError("What's the school's name?")
        } else {
            let school = School(name: addSchoolView.name.textField.text, location: self.location, director: self.director)
            AdminOperations.createSchool(school, completion: { (createdSchool) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (message) -> Void in
                    self.showAlertControllerError(message)
            })
        }
    }
    
    func showErrorAndSetMessage(message: String) {
        let error = self.currentErrorMessage
        let errorView = self.showError(message, currentError: error, color: UIColor.mainColor)
        self.currentErrorMessage = errorView
    }
    
    func didSelectDirector(director: User) {
        self.director = director
        (self.view as! AddSchoolView).displayChosenDirector(director)
    }
    
    func didSelectPlace(prediction: GMSAutocompletePrediction) {
        let placeID = prediction.placeID
        let placeClient = GMSPlacesClient.sharedClient()
        placeClient.lookUpPlaceID(placeID) { (predictedPlace, error) -> Void in
            if let place = predictedPlace {
                self.location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                (self.view as! AddSchoolView).displayChosenPlace(place)
            }
        }
    }

}
