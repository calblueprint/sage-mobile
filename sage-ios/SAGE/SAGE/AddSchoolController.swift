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
    var place: GMSPlace?
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
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(tableViewController, animated: true)
    }
    
    func directorButtonTapped() {
        let tableViewController = AddSchoolDirectorTableViewController()
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(tableViewController, animated: true)
    }
    
    @objc private func completeForm() {
        let addSchoolView = (self.view as! AddSchoolView)
        if addSchoolView.name.textField.text != nil || addSchoolView.name.textField.text != "" {
            self.showErrorAndSetMessage("What's the school's name?", size: 64.0)
        } else if !addSchoolView.choseDirector {
            self.showErrorAndSetMessage("Please choose a director", size: 64.0)
        } else if !addSchoolView.choseLocation {
            self.showErrorAndSetMessage("Please choose a location", size: 64.0)
        } else {
            // make a network request here
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func showErrorAndSetMessage(message: String, size: CGFloat) {
        let error = self.currentErrorMessage
        let errorView = super.showError(message, size: size, currentError: error)
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
                self.place = place
                (self.view as! AddSchoolView).displayChosenPlace(place)
            }
        }
    }

}
