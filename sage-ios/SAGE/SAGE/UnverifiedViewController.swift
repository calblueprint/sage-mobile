//
//  UnverifiedViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class UnverifiedViewController: UIViewController {
    
    
    override func loadView() {
        self.view = UnverifiedView()
        let unverifiedView = self.view as! UnverifiedView
        unverifiedView.signOutButton.addTarget(self, action: "signOut", forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLoad() {
        if let imageString = LoginOperations.getUser()?.imgURL {
            let imageURL = NSURL(string: imageString)
            let imageData = NSData(contentsOfURL: imageURL!)
            let image = UIImage(data: imageData!)
            (self.view as! UnverifiedView).photo.contentMode = .ScaleAspectFill
            (self.view as! UnverifiedView).photo.image = image

        } else {
            let imageURL = NSURL(string: UserConstants.defaultImage)
            let imageData = NSData(contentsOfURL: imageURL!)
            let image = UIImage(data: imageData!)
            (self.view as! UnverifiedView).photo.contentMode = .ScaleAspectFill
            (self.view as! UnverifiedView).photo.image = image
        }
    }
    
    func signOut() {
        let loginController = LoginController()
        LoginOperations.deleteUserKeychainData()
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
