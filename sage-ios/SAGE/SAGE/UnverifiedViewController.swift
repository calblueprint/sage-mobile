//
//  UnverifiedViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class UnverifiedViewController: SGViewController {
    
    
    override func loadView() {
        self.view = UnverifiedView()
        let unverifiedView = self.view as! UnverifiedView
        unverifiedView.signOutButton.addTarget(self, action: #selector(UnverifiedViewController.signOut), forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLoad() {
        if let imageURL = SAGEState.currentUser()?.imageURL {
            (self.view as! UnverifiedView).photo.setImageWithURL(imageURL)
        } else {
            (self.view as! UnverifiedView).photo.image = UIImage.defaultProfileImage()
        }
        (self.view as! UnverifiedView).photo.contentMode = .ScaleAspectFill

    }
    
    deinit {
        (self.view as! UnverifiedView).photo.cancelImageRequestOperation()
    }
    
    func signOut() {
        let loginController = LoginController()
        SAGEState.reset()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.presentViewController(loginController, animated: true, completion: nil)
    }
    
    //
    // MARK: - Public methods
    //
    func setImage(image: UIImage) {
        (self.view as! UnverifiedView).photo.contentMode = .ScaleAspectFill
        (self.view as! UnverifiedView).photo.image = image
    }
}
