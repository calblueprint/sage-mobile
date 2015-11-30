//
//  ProfileViewController.swift
//  SAGE
//
//  Created by Erica Yin on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class ProfileViewController: UIViewController {

    var currentUser = User()
    var profileView = ProfileView()
    
    override func loadView() {
        self.view = self.profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.getUser()
    }
    
    func getUser() {
        ProfileOperations.getUser({ (user) -> Void in
            self.currentUser = user
            self.profileView.setupWithUser(user)
            }) { (errorMessage) -> Void in
                //display error
        }
    }
}
