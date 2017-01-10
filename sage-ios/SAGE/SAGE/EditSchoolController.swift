//
//  EditSchoolController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/30/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class EditSchoolController: AddSchoolController {
    
    var school: School?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit School"
        (self.view as! AddSchoolView).deleteSchoolButton.addTarget(self, action: #selector(EditSchoolController.deleteSchool(_:)), forControlEvents: .TouchUpInside)
    }
    
    func configureWithSchool(school: School?) {
        self.school = school?.copy() as? School
        (self.view as! AddSchoolView).displaySchoolName(school?.name)
        (self.view as! AddSchoolView).deleteSchoolButton.hidden = false

        if let director = self.school?.director {
            self.didSelectDirector(director)
        }
        if let radius = self.school?.radius {
            self.didSelectRadius(radius)
        }
        if let location = self.school?.location {
            self.location = location
        }
        if let address = self.school?.address {
            (self.view as! AddSchoolView).displayAddressText(address)
        } else {
            if let location = self.school?.location {
                let geocoder = GMSGeocoder()
                geocoder.reverseGeocodeCoordinate(location.coordinate, completionHandler: { (callback, error) -> Void in
                    if error == nil {
                        let address = callback!.firstResult()
                        let addressText = address!.lines![0] as? String
                        school!.address = addressText
                        (self.view as! AddSchoolView).displayAddressText(addressText)
                    }
                })
            }
        }
    }
    
    override func locationButtonTapped() {
        let vc = AddSchoolLocationTableViewController()
        vc.parentVC = self
        if let location = self.location {
            vc.configureWithLocation(location)
        } else if let location = self.school?.location {
            vc.configureWithLocation(location)
        }
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func completeForm() {
        let addSchoolView = (self.view as! AddSchoolView)
        if addSchoolView.name.textField.text == nil || addSchoolView.name.textField.text == "" {
            self.showAlertControllerError("Please enter a name.")
        } else {
            self.school?.name = addSchoolView.name.textField.text
            if let director = self.director {
                self.school?.director = director
            }
            if let location = self.location {
                self.school?.location = location
            }
            if let address = self.address {
                self.school?.address = address
            }
            if let radius = self.radius {
                self.school?.radius = radius
            }
            self.finishButton?.startLoading()
            (self.view as! AddSchoolView).deleteSchoolButton.hidden = true
            AdminOperations.editSchool(self.school!, completion: { (editedSchool) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editSchoolKey, object: editedSchool)
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (message) -> Void in
                    self.finishButton?.stopLoading()
                    (self.view as! AddSchoolView).deleteSchoolButton.hidden = false
                    self.showAlertControllerError(message)
            })
        }
    }

    func deleteSchool(sender: UIButton!) {
        let view = (self.view as! AddSchoolView)

        let deleteHandler: (UIAlertAction) -> Void = { _ in
            view.deleteSchoolButton.startLoading()
            self.finishButton?.startLoading()
            SchoolOperations.deleteSchool(self.school!, completion: { (school) -> Void in
                self.navigationController!.popToViewController(self.navigationController!.viewControllers[self.navigationController!.viewControllers.count-3], animated: true)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.deleteSchoolKey, object: self.school)
                }) { (errorMessage) -> Void in
                    view.deleteSchoolButton.stopLoading()
                    self.finishButton?.stopLoading()
                    let alertController = UIAlertController(
                        title: "Failure",
                        message: errorMessage as String,
                        preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
            }
        }

        let alertController = UIAlertController(
            title: "Delete School",
            message: "Are you sure you want to delete this school? This action cannot be undone.",
            preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .Default, handler: deleteHandler))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
