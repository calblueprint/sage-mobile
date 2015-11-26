//
//  BrowseSchoolsDetailViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseSchoolsDetailViewController: UIViewController {

    var schoolDetailView: SchoolDetailView = SchoolDetailView()
    var schoolLocation:  CLLocation?
    
    override func loadView() {
        self.view = self.schoolDetailView
    }
    
    func configureWithSchool(school: School) {
        self.title = school.name!
        self.schoolLocation = school.location!
        self.schoolDetailView.schoolName.text = school.name!
        self.schoolDetailView.directorName.text = "director name"
        self.schoolDetailView.studentsList.text = "some studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome studentssome students"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let marker = GMSMarker(position: self.schoolLocation!.coordinate)
        marker.map = self.schoolDetailView.mapView
        self.schoolDetailView.mapView.moveCamera(GMSCameraUpdate.setTarget(self.schoolLocation!.coordinate))
        // Do any additional setup after loading the view.
    }

}
