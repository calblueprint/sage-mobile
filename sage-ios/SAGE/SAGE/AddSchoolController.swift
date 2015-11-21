//
//  AddSchoolController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddSchoolController: UIViewController {

    override func viewDidLoad() {
        self.view = AddSchoolView()
        self.title = "Add School"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .Done, target: self, action: "completeForm")
    }
    
    @objc private func completeForm() {

    }

}
