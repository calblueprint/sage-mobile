//
//  EditProfileController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class EditProfileController: UIViewController {
    
    var user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
//        let editProfileView = editProfileView(frame: self.view.frame)
//        self.view = editProfileView
//        self.title = "Edit Profile"
//        self.finishButton = SGBarButtonItem(title: "Finish", style: .Done, target: self, action: "completeForm")
//        self.navigationItem.rightBarButtonItem = self.finishButton
//        addSchoolView.location.button.addTarget(self, action: "locationButtonTapped", forControlEvents: .TouchUpInside)
//        addSchoolView.director.button.addTarget(self, action: "directorButtonTapped", forControlEvents: .TouchUpInside)
    }

}
