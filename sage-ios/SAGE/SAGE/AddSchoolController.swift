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

    }
    
    func didSelectDirector(director: User) {
        self.director = director
        (self.view as! AddSchoolView).displayChosenDirector(director)
    }

}
