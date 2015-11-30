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
    var chosenName: String?
    var chosenDirector: User?
    var chosenLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit School"
    }
    
    func configureWithSchool(school: School?) {
        self.school = school
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
}
