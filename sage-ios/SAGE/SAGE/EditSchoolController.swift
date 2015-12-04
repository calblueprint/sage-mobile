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
    }
    
    func configureWithSchool(school: School?) {
        self.school = school?.copy() as? School
        (self.view as! AddSchoolView).displaySchoolName(school?.name)
        if let director = self.school?.director {
            self.didSelectDirector(director)
        }
        if let location = self.school?.location {
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(location.coordinate, completionHandler: { (callback, error) -> Void in
                if error == nil {
                    let address = callback.firstResult()
                    let addressText = address.lines[0] as? String
                    (self.view as! AddSchoolView).displayAddressText(addressText)
                }
            })
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
            AdminOperations.editSchool(self.school!, completion: { (editedSchool) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editSchoolKey, object: editedSchool.copy())
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (message) -> Void in
                    self.showAlertControllerError(message)
            })
        }
    }
}
