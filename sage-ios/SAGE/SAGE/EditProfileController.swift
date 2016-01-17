//
//  EditProfileController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class EditProfileController: FormController {
    
    var user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let editProfileView = EditProfileView(frame: self.view.frame)
        self.view = editProfileView
        self.title = "Edit Profile"
        editProfileView.displayFirstName(self.user.firstName!)
        editProfileView.displayLastName(self.user.lastName!)
        editProfileView.displayEmail(self.user.email!)
        editProfileView.displaySchoolName(self.user.school!.name!)
        editProfileView.displayHours(self.user.level)
        editProfileView.setProfileImage(self.user)
    }

}
