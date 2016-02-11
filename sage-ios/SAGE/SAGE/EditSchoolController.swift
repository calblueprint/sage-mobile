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
        (self.view as! AddSchoolView).deleteSchoolButton.addTarget(self, action: "deleteSchool:", forControlEvents: .TouchUpInside)
    }
    
    func configureWithSchool(school: School?) {
        self.school = school?.copy() as? School
        (self.view as! AddSchoolView).displaySchoolName(school?.name)
        (self.view as! AddSchoolView).deleteSchoolButton.hidden = false

        if let director = self.school?.director {
            self.didSelectDirector(director)
        }
        if let address = self.school?.address {
            (self.view as! AddSchoolView).displayAddressText(address)
        } else {
            if let location = self.school?.location {
                let geocoder = GMSGeocoder()
                geocoder.reverseGeocodeCoordinate(location.coordinate, completionHandler: { (callback, error) -> Void in
                    if error == nil {
                        let address = callback.firstResult()
                        let addressText = address.lines[0] as? String
                        school!.address = addressText
                        (self.view as! AddSchoolView).displayAddressText(addressText)
                    }
                })
            }
        }
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
            self.finishButton?.startLoading()
            AdminOperations.editSchool(self.school!, completion: { (editedSchool) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editSchoolKey, object: editedSchool)
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (message) -> Void in
                    self.finishButton?.stopLoading()
                    self.showAlertControllerError(message)
            })
        }
    }

    func deleteSchool(sender: UIButton!) {
        let view = (self.view as! AddSchoolView)

        let deleteHandler: (UIAlertAction) -> Void = { _ in
            view.deleteSchoolButton.startLoading()
            self.finishButton?.startLoading()
            SchoolOperations.deleteSchool(self.school!, completion: { (announcement) -> Void in
//                self.dismissViewControllerAnimated(true, completion: nil)
//                self.navigationController!.popToRootViewControllerAnimated(true)
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
