//
//  SignUpController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    override func loadView() {
        self.view = SignUpView()
        self.setUpTargetActionPairs()
    }
    
    func setUpTargetActionPairs(){
        let signUpView = (self.view as! SignUpView)
        let schoolHoursView = signUpView.schoolHoursView
        let photoView = signUpView.photoView
        
        signUpView.xButton.addTarget(self, action: "xButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        schoolHoursView.chooseSchoolButton.addTarget(self, action: "presentSchoolModal", forControlEvents: UIControlEvents.TouchUpInside)
        
        schoolHoursView.chooseHoursButton.addTarget(self, action: "presentHoursModal", forControlEvents: UIControlEvents.TouchUpInside)
        
        photoView.photoButton.addTarget(self, action: "choosePhoto", forControlEvents: UIControlEvents.TouchUpInside)
        
        photoView.skipAndFinishLink.addTarget(self, action: "createAccountAndProceedToAppWithoutPicture", forControlEvents: UIControlEvents.TouchUpInside)
        
        photoView.finishButton.addTarget(self, action: "createAccountAndProceedToAppWithPicture", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func createAccountAndProceedToAppWithoutPicture() {
        let unverifiedController = UnverifiedViewController()
        self.presentViewController(unverifiedController, animated: true, completion: nil)
    }
    
    func createAccountAndProceedToAppWithPicture() {
        let unverifiedController = UnverifiedViewController()
        let signUpView = (self.view as! SignUpView)
        let photoView = signUpView.photoView
        unverifiedController.setImage(photoView.photo.image!)
        self.presentViewController(unverifiedController, animated: true, completion: nil)
    }
    
    func choosePhoto() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose From Library", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            actionSheet.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let signUpView = (self.view as! SignUpView)
        let photoView = signUpView.photoView
        
        photoView.photo.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoView.finishButton.hidden = false
        photoView.finishLabel.hidden = false
        photoView.photoButton.hidden = true
        photoView.photoLabel.hidden = true
        photoView.skipAndFinishLink.hidden = true
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func presentSchoolModal() {
        let tableViewController = SignUpTableViewController()
        let navigationController = UINavigationController(rootViewController: tableViewController)
        tableViewController.parentVC = self
        self.presentViewController(navigationController, animated: true, completion: nil)
        tableViewController.setType("School")
    }
    
    func presentHoursModal() {
        let tableViewController = SignUpTableViewController()
        let navigationController = UINavigationController(rootViewController: tableViewController)
        tableViewController.parentVC = self
        self.presentViewController(navigationController, animated: true, completion: nil)
        tableViewController.setType("Hours")
    }
    
    func xButtonPressed() {
        self.dismissViewControllerAnimated(false, completion: nil)
        UIView.animateWithDuration(UIView.animationTime) { () -> Void in
            self.view.alpha = 0.0
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0.0
        UIView.animateWithDuration(UIView.animationTime/2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.alpha = 1.0
        }, completion: nil)
    }
}
